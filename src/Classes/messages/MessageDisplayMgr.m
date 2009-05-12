//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDisplayMgr.h"

@implementation MessageDisplayMgr

- (void)dealloc
{
    [messageCache release];
    [responseCache release];
    [messagesViewController release];
    [wrapperController release];

    [newMessageViewController release];
    [detailsViewController release];

    // TEMPORARY
    [userDict release];
    [projectDict release];
    // TEMPORARY
    
    [super dealloc];
}

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    messageResponseCache:(MessageResponseCache *)aMessageResponseCache
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController
{
    if (self = [super init]) {
        messageCache = [aMessageCache retain];
        responseCache = [aMessageResponseCache retain];
        wrapperController = [aWrapperController retain];
        messagesViewController = [aMessagesViewController retain];
        
        // TEMPORARY
        // this will eventually be read from a user cache of some sort
        userDict = [[NSMutableDictionary dictionary] retain];
        [userDict setObject:@"Doug Kurth" forKey:[NSNumber numberWithInt:0]];
        [userDict setObject:@"John A. Debay" forKey:[NSNumber numberWithInt:1]];
        
        projectDict = [[NSMutableDictionary dictionary] retain];
        [projectDict setObject:@"Code Watch" forKey:[NSNumber numberWithInt:0]];
        [projectDict setObject:@"Bug Watch" forKey:[NSNumber numberWithInt:1]];
        // TEMPORARY
    }

    return self;
}

#pragma mark MessagesViewControllerDelegate implementation

- (void)showAllMessages
{
    // TEMPORARY
    wrapperController.cachedDataAvailable = YES;
    [wrapperController setUpdatingState:kConnectedAndNotUpdating];
    // TEMPORARY
    
    NSMutableDictionary * postedByDict = [NSMutableDictionary dictionary];
    NSDictionary * allPostedByKeys = [messageCache allPostedByKeys];
    for (id key in allPostedByKeys) {
        id postedByKey = [allPostedByKeys objectForKey:key];
        NSString * postedByName = [userDict objectForKey:postedByKey];
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

@end
