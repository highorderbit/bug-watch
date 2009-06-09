//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDisplayMgr.h"

@interface MessageDisplayMgr (Private)

- (void)displayCachedMessages;

@end

@implementation MessageDisplayMgr

@synthesize messageCache, userDict, projectDict, activeProjectKey;

- (void)dealloc
{
    [messageCache release];
    [responseCache release];
    [dataSource release];
    [messagesViewController release];
    [wrapperController release];

    [newMessageViewController release];
    [detailsViewController release];

    [userDict release];
    [projectDict release];

    [activeProjectKey release];

    [super dealloc];
}

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    messageResponseCache:(MessageResponseCache *)aMessageResponseCache
    dataSource:(MessageDataSource *)aDataSource
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController
{
    if (self = [super init]) {
        messageCache = [aMessageCache retain];
        responseCache = [aMessageResponseCache retain];
        dataSource = [aDataSource retain];
        wrapperController = [aWrapperController retain];
        messagesViewController = [aMessagesViewController retain];
        
        self.activeProjectKey = nil;
        wrapperController.cachedDataAvailable = NO;
    }

    return self;
}

#pragma mark MessagesViewControllerDelegate implementation

- (void)showAllMessages
{
    NSLog(@"Showing messages...");
    // Make sure we've received a project dictionary already, otherwise wait
    // and show all messages after it has arrived
    if (self.activeProjectKey || self.projectDict) {
        wrapperController.cachedDataAvailable = !!messageCache;

        if (messageCache) 
            [self displayCachedMessages];

        resetCache = YES;
        [wrapperController setUpdatingState:kConnectedAndUpdating];
        if (!self.activeProjectKey) {
            for (id projectKey in [self.projectDict allKeys])
                [dataSource fetchMessagesForProject:projectKey];
        } else
            [dataSource fetchMessagesForProject:self.activeProjectKey];
    }
}

- (void)displayCachedMessages
{
    NSMutableDictionary * postedByDict = [NSMutableDictionary dictionary];
    NSDictionary * allPostedByKeys = [messageCache allPostedByKeys];
    for (id key in allPostedByKeys) {
        id postedByKey = [allPostedByKeys objectForKey:key];
        NSString * postedByName = [userDict objectForKey:postedByKey];
        if (postedByName)
            [postedByDict setObject:postedByName forKey:key];
    }

    NSMutableDictionary * msgProjectDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * numResponsesDict = [NSMutableDictionary dictionary];

    NSArray * allMessageKeys = [[messageCache allMessages] allKeys];
    for (id key in allMessageKeys) {
        NSUInteger respCount = [[messageCache responseKeysForKey:key] count];
        NSNumber * respCountAsNum = [NSNumber numberWithInt:respCount];
        [numResponsesDict setObject:respCountAsNum forKey:key];
    }

    [messagesViewController setMessages:[messageCache allMessages]
        postedByDict:postedByDict projectDict:msgProjectDict
        numResponsesDict:numResponsesDict];
}

- (void)selectedMessageKey:(id)key
{
    NSLog(@"Message %@ selected", key);
    [self.navController
        pushViewController:self.detailsViewController animated:YES];

    Message * message = [messageCache messageForKey:key];
    NSString * postedBy =
        [userDict objectForKey:[messageCache postedByKeyForKey:key]];
    NSString * project =
        [projectDict objectForKey:[messageCache projectKeyForKey:key]];
    NSArray * responseKeys = [messageCache responseKeysForKey:key];
    NSMutableDictionary * responses = [NSMutableDictionary dictionary];
    NSMutableDictionary * responseAuthors = [NSMutableDictionary dictionary];
    for (id key in responseKeys) {
        MessageResponse * response = [responseCache responseForKey:key];
        [responses setObject:response forKey:key];
        id authorKey = [responseCache authorKeyForKey:key];
        NSString * authorName = [userDict objectForKey:authorKey];
        [responseAuthors setObject:authorName forKey:key];
    }

    [self.detailsViewController setAuthorName:postedBy date:message.postedDate
        projectName:project title:message.title comment:message.message
        responses:responses responseAuthors:responseAuthors];
}

#pragma mark NetworkAwareViewControllerDelegate

- (void)networkAwareViewWillAppear
{
    [self showAllMessages];
}

#pragma mark MessageDataSourceDelegate implementation

- (void)receivedMessagesFromDataSource:(MessageCache *)aMessageCache
{
    NSLog(@"Received messages from data source: %@", aMessageCache);
    [wrapperController setUpdatingState:kConnectedAndNotUpdating];
    if (resetCache)
        self.messageCache = aMessageCache;
    else
        [self.messageCache merge:aMessageCache];
    [self displayCachedMessages];
    resetCache = NO;
}

#pragma mark MessageDisplayMgr implementation

- (void)createNewMessage
{
    NSLog(@"Presenting 'create message' view");
    [self.navController presentModalViewController:self.newMessageViewController
        animated:YES];
}

#pragma mark Accessors

- (NewMessageViewController *)newMessageViewController
{
    if (!newMessageViewController) {
        newMessageViewController =
            [[NewMessageViewController alloc]
            initWithNibName:@"NewMessageView" bundle:nil];
    }

    return newMessageViewController;
}

- (MessageDetailsViewController *)detailsViewController
{
    if (!detailsViewController) {
        detailsViewController =
            [[MessageDetailsViewController alloc]
            initWithNibName:@"MessageDetailsView" bundle:nil];
    }

    return detailsViewController;
}

- (UINavigationController *)navController
{
    return wrapperController.navigationController;
}

- (void)setProjectDict:(NSDictionary *)aProjectDict
{
    NSDictionary * tempProjectDict = [aProjectDict copy];
    [projectDict release];
    projectDict = tempProjectDict;

    [self showAllMessages];
}

- (void)setUserDict:(NSDictionary *)aUserDict
{
    NSDictionary * tempUserDict = [aUserDict copy];
    [userDict release];
    userDict = tempUserDict;

    [self showAllMessages];
}

@end
