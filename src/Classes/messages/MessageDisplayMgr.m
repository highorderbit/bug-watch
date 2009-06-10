//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDisplayMgr.h"

@interface MessageDisplayMgr (Private)

- (void)initDarkTransparentView;
- (void)displayCachedMessages;
- (void)disableEditViewWithText:(NSString *)text;
- (void)enableEditView;
- (void)updateDisplayIfDirty;

@end

@implementation MessageDisplayMgr

@synthesize messageCache, userDict, projectDict, activeProjectKey,
    selectProject;

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

    [darkTransparentView release];
    [loadingLabel release];

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
        self.selectProject = YES;
        displayDirty = YES;

        [self initDarkTransparentView];
    }

    return self;
}

- (void)initDarkTransparentView
{
    CGRect darkTransparentViewFrame = CGRectMake(0, 0, 320, 480);
    darkTransparentView =
        [[UIView alloc] initWithFrame:darkTransparentViewFrame];

    CGRect transparentViewFrame = CGRectMake(0, 0, 320, 480);
    UIView * transparentView =
        [[[UIView alloc] initWithFrame:transparentViewFrame] autorelease];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.8;
    [darkTransparentView addSubview:transparentView];
    
    CGRect activityIndicatorFrame = CGRectMake(142, 85, 37, 37);
    UIActivityIndicatorView * activityIndicator =
        [[UIActivityIndicatorView alloc] initWithFrame:activityIndicatorFrame];
    activityIndicator.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicator startAnimating];
    [darkTransparentView addSubview:activityIndicator];
    
    CGRect loadingLabelFrame = CGRectMake(21, 120, 280, 65);
    loadingLabel = [[UILabel alloc] initWithFrame:loadingLabelFrame];
    loadingLabel.text = @"Creating ticket...";
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:20];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [darkTransparentView addSubview:loadingLabel];
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
        if (selectProject) {
            for (id projectKey in [self.projectDict allKeys])
                [dataSource fetchMessagesForProject:projectKey];
        } else
            [dataSource fetchMessagesForProject:self.activeProjectKey];
    }
}

- (void)updateDisplayIfDirty
{
    if (displayDirty) {
        [self showAllMessages];
        displayDirty = NO;
    }
}

- (void)displayCachedMessages
{
    if (messageCache) {
        NSMutableDictionary * postedByDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * msgProjectDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * numResponsesDict =
            [NSMutableDictionary dictionary];

        NSArray * allMessageKeys = [[messageCache allMessages] allKeys];
        for (id key in allMessageKeys) {
            NSUInteger respCount =
                [[messageCache responseKeysForKey:key] count];
            NSNumber * respCountAsNum = [NSNumber numberWithInt:respCount];
            [numResponsesDict setObject:respCountAsNum forKey:key];

            id postedByKey = [messageCache postedByKeyForKey:key];
            NSString * postedByName = [userDict objectForKey:postedByKey];
            if (postedByName)
                [postedByDict setObject:postedByName forKey:key];
        
            id projectKey = [messageCache projectKeyForKey:key];
            NSString * projectName = [projectDict objectForKey:projectKey];
            if (projectName)
                [msgProjectDict setObject:projectName forKey:key];
        }

        [messagesViewController setMessages:[messageCache allMessages]
            postedByDict:postedByDict projectDict:msgProjectDict
            numResponsesDict:numResponsesDict];

        wrapperController.cachedDataAvailable = YES;
    }
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
    [self updateDisplayIfDirty];
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

- (void)createdMessageWithKey:(id)key
{
    [self enableEditView];
    [self showAllMessages];
}

#pragma mark NewMessageViewControllerDelegate implementation

- (void)postNewMessage:(NSString *)message withTitle:(NSString *)title
{
    NSLog(@"Posting message to server: %@", title);
    [self disableEditViewWithText:@"Posting message..."];
    NewMessageDescription * description = [NewMessageDescription description];
    description.title = title;
    description.body = message;
    [dataSource createMessageWithDescription:description
        forProject:self.activeProjectKey];
}

#pragma mark MessageDisplayMgr implementation

- (void)createNewMessage
{
    NSLog(@"Presenting 'create message' view");

    UIViewController * rootViewController;

    if (selectProject) {
        rootViewController = self.projectSelectionViewController;
        self.projectSelectionViewController.projects = projectDict;
    } else
        rootViewController = self.newMessageViewController;

    UINavigationController * tempNavController =
        [[[UINavigationController alloc]
        initWithRootViewController:rootViewController]
        autorelease];

    [self.navController presentModalViewController:tempNavController
        animated:YES];
}

- (void)userDidSelectActiveProjectKey:(id)key
{
    NSLog(@"User selected project %@ for message editing", key);
    self.activeProjectKey = key;
    [self.projectSelectionViewController.navigationController
        pushViewController:self.newMessageViewController animated:YES];
}

- (void)disableEditViewWithText:(NSString *)text
{
    loadingLabel.text = text;
    [self.newMessageViewController.view.superview
        addSubview:darkTransparentView];
    self.newMessageViewController.cancelButton.enabled = NO;
    self.newMessageViewController.postButton.enabled = NO;
}

- (void)enableEditView
{
    [darkTransparentView removeFromSuperview];
    [self.newMessageViewController dismissModalViewControllerAnimated:YES];
    self.newMessageViewController.cancelButton.enabled = YES;
    self.newMessageViewController.postButton.enabled = YES;
}

#pragma mark Accessors

- (NewMessageViewController *)newMessageViewController
{
    if (!newMessageViewController) {
        newMessageViewController =
            [[NewMessageViewController alloc]
            initWithNibName:@"NewMessageView" bundle:nil];
    }
    newMessageViewController.navigationItem.hidesBackButton = YES;
    newMessageViewController.delegate = self;

    return newMessageViewController;
}

- (ProjectSelectionViewController *)projectSelectionViewController
{
    if (!projectSelectionViewController) {
        projectSelectionViewController =
            [[ProjectSelectionViewController alloc]
            initWithNibName:@"ProjectSelectionView" bundle:nil];
        projectSelectionViewController.target = self;
        projectSelectionViewController.action =
            @selector(userDidSelectActiveProjectKey:);
    }

    return projectSelectionViewController;
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
    [self displayCachedMessages];
}

- (void)setUserDict:(NSDictionary *)aUserDict
{
    NSDictionary * tempUserDict = [aUserDict copy];
    [userDict release];
    userDict = tempUserDict;
    [self displayCachedMessages];
}

@end
