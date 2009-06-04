//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"
#import "TicketDetailsViewController.h"
#import "NewsFeedViewController.h"
#import "LighthouseNewsFeedService.h"
#import "NetworkAwareViewController.h"
#import "TicketComment.h"
#import "MilestoneDetailsDataSource.h"
#import "MilestoneDetailsDisplayMgr.h"
#import "ProjectDisplayMgr.h"
#import "LighthouseApiService.h"
#import "MilestoneDataSource.h"
#import "MessageDisplayMgr.h"
#import "TicketsViewController.h"
#import "TicketDataSource.h"
#import "TicketSearchMgr.h"
#import "MessageResponseCache.h"
#import "AccountLevelTicketBinDataSource.h"
#import "TicketPersistenceStore.h"
#import "MilestoneUpdatePublisher.h"
#import "UIStatePersistenceStore.h"
#import "UIState.h"
#import "ProjectUpdatePublisher.h"
#import "UserSetAggregator.h"
#import "TicketDispMgrUserSetter.h"
#import "NewsFeedPersistenceStore.h"
#import "MilestonePersistenceStore.h"
#import "ProjectPersistenceStore.h"
#import "UserPersistenceStore.h"
#import "AllUserUpdatePublisher.h"
#import "ProjectDispMgrProjectSetter.h"

@interface BugWatchAppController (Private)

- (void)initTicketsTab;
- (TicketDisplayMgr *)createTicketDispMgr:(TicketCache *)ticketCache
    addButton:(UIBarButtonItem *)addButton
    searchField:(UITextField *)searchField
    wrapperController:(NetworkAwareViewController *)wrapperController
    parentView:(UIView *)parentView
    ticketBinDataSource:(id)ticketBinDataSource;
- (TicketCache *)loadTicketsFromPersistence;

- (void)initProjectsTab;
- (void)initMessagesTab;
- (void)initNewsFeedTab;
- (void)initMilestonesTab;

- (void)initSharedStateListeners;
+ (void)loadSharedStatesFromPersistence;
+ (void)broadcastMilestoneCache:(MilestoneCache *)cache;
+ (void)broadcastProjectCache:(ProjectCache *)cache;
+ (void)broadcastUserCache:(UserCache *)cache;

+ (NSString *)newsFeedCachePlist;
+ (NSString *)ticketCachePlist;
+ (NSString *)projectCachePlist;
+ (NSString *)milestoneCachePlist;
+ (NSString *)userCachePlist;

@end

@implementation BugWatchAppController

- (void)dealloc
{
    [newsFeedNetworkAwareViewController release];
    [ticketsNetAwareViewController release];
    [projectsNetAwareViewController release];
    [milestonesNetworkAwareViewController release];
    [messagesNetAwareViewController release];
    [pagesViewController release];

    [newsFeedDisplayMgr release];
    [newsFeedDataSource release];

    [ticketDisplayMgrFactory release];
    [ticketDisplayMgr release];
    [projectLevelTicketDisplayMgr release];
    [ticketSearchMgrFactory release];

    [projectCacheSetter release];

    [messageCache release];
    [messageResponseCache release];

    [milestoneDisplayMgr release];
    [milestoneCacheSetter release];

    [userCacheSetter release];

    [lighthouseApiFactory release];

    [super dealloc];
}

#pragma mark Public interface implementation

- (void)start
{
    NSString * baseServiceUrl = @"https://highorderbit.lighthouseapp.com/"; // TEMPORARY
    NSString * token = @"6998f7ed27ced7a323b256d83bd7fec98167b1b3"; // TEMPORARY

    lighthouseApiFactory =
        [[LighthouseApiServiceFactory alloc] initWithBaseUrl:baseServiceUrl];
    ticketSearchMgrFactory =
        [[TicketSearchMgrFactory alloc] init];
    ticketDisplayMgrFactory =
        [[TicketDisplayMgrFactory alloc] initWithApiToken:token
        lighthouseApiFactory:lighthouseApiFactory];

    [self initSharedStateListeners];

    messageCache = [[MessageCache alloc] init];
    messageResponseCache = [[MessageResponseCache alloc] init];

    // load single-session, global data (milestones, projects, users)
    LighthouseApiService * service =
        [[lighthouseApiFactory createLighthouseApiService] retain];

    [service fetchMilestonesForAllProjects:token];
    [service fetchAllProjects:token];

    // TEMPORARY: populate message cache
    Message * msg1 =
       [[Message alloc] initWithPostedDate:[NSDate date]
       title:@"App Store Description"
       message:@"Code Watch is the best way to get GitHub on your iPhone.\nKeep track of what's going on with all of your GitHub repositories, including your private ones."];
    Message * msg2 =
        [[Message alloc] initWithPostedDate:[NSDate date]
        title:@"What should we do with private information after logging out?"
        message:@"We don't really address this issue at all, currently. Off the top of my head, I suppose we should clear the primary user info (do we do that currently?), clear the news feed cache, and remove all repos in the repo cache marked as private. We could also just do the easy thing and clear all caches with potentially private information. Actually, I would probably favor the last solution. It's easy, and I don't think this use-case will be very common."];
    [messageCache setMessage:msg1 forKey:[NSNumber numberWithInt:0]];
    [messageCache setMessage:msg2 forKey:[NSNumber numberWithInt:1]];
    [messageCache setPostedByKey:[NSNumber numberWithInt:0]
        forKey:[NSNumber numberWithInt:1]];
    [messageCache setPostedByKey:[NSNumber numberWithInt:1]
        forKey:[NSNumber numberWithInt:0]];

    [messageCache setResponseKeys:[NSArray array]
        forKey:[NSNumber numberWithInt:0]];
    NSMutableArray * responseKeys = [NSMutableArray array];
    [responseKeys addObject:[NSNumber numberWithInt:0]];
    [responseKeys addObject:[NSNumber numberWithInt:1]];
    [messageCache setResponseKeys:responseKeys
        forKey:[NSNumber numberWithInt:0]];
        
    [messageCache setProjectKey:[NSNumber numberWithInt:0]
        forKey:[NSNumber numberWithInt:1]];
    [messageCache setProjectKey:[NSNumber numberWithInt:1]
        forKey:[NSNumber numberWithInt:0]];

    MessageResponse * msgResp1 =
        [[[MessageResponse alloc]
        initWithText:@"My response 1" date:[NSDate date]] autorelease];
    MessageResponse * msgResp2 =
        [[[MessageResponse alloc]
        initWithText:@"My response 2 My response 2 My response 2 My response 2"
        date:[NSDate date]] autorelease];
    [messageResponseCache setResponse:msgResp1
        forKey:[NSNumber numberWithInt:0]];
    [messageResponseCache setResponse:msgResp2
        forKey:[NSNumber numberWithInt:1]];
    [messageResponseCache setAuthorKey:[NSNumber numberWithInt:0]
        forKey:[NSNumber numberWithInt:0]];
    [messageResponseCache setAuthorKey:[NSNumber numberWithInt:1]
        forKey:[NSNumber numberWithInt:1]];
    // TEMPORARY

    [self initTicketsTab];
    [self initProjectsTab];
    [self initMessagesTab];
    [self initNewsFeedTab];
    [self initMilestonesTab];

    UIStatePersistenceStore * uiStatePersistenceStore =
        [[[UIStatePersistenceStore alloc] init] autorelease];
    UIState * uiState = [uiStatePersistenceStore load];
    tabBarController.selectedIndex = uiState.selectedTab;

    [[self class] loadSharedStatesFromPersistence];
}

- (void)persistState
{
    NSLog(@"Persisting state...");

    NewsFeedPersistenceStore * newsFeedPersistenceStore =
        [[[NewsFeedPersistenceStore alloc] init] autorelease];
    [newsFeedPersistenceStore saveNewsItems:newsFeedDataSource.cache
        toPlist:[[self class] newsFeedCachePlist]];

    TicketCache * ticketCache = ticketDisplayMgr.ticketCache;
    TicketPersistenceStore * ticketPersistenceStore =
        [[[TicketPersistenceStore alloc] init] autorelease];
    [ticketPersistenceStore saveTicketCache:ticketCache
        toPlist:[[self class] ticketCachePlist]];

    MilestonePersistenceStore * milestonePersistenceStore =
        [[[MilestonePersistenceStore alloc] init] autorelease];
    [milestonePersistenceStore save:milestoneCacheSetter.cache
        toPlist:[[self class] milestoneCachePlist]];
        
    ProjectPersistenceStore * projectPersistenceStore =
        [[[ProjectPersistenceStore alloc] init] autorelease];
    [projectPersistenceStore saveProjectCache:projectCacheSetter.cache
        toPlist:[[self class] projectCachePlist]];
        
    UserPersistenceStore * userPersistenceStore =
        [[[UserPersistenceStore alloc] init] autorelease];
    [userPersistenceStore saveUserCache:userCacheSetter.cache
        toPlist:[[self class] userCachePlist]];

    UIStatePersistenceStore * uiStatePersistenceStore =
        [[[UIStatePersistenceStore alloc] init] autorelease];
    UIState * uiState = [[[UIState alloc] init] autorelease];
    uiState.selectedTab = tabBarController.selectedIndex;
    [uiStatePersistenceStore save:uiState];
}

- (void)initSharedStateListeners
{
    milestoneCacheSetter = [[MilestoneCacheSetter alloc] init];
    [[MilestoneUpdatePublisher alloc]
        initWithListener:milestoneCacheSetter
        action:
        @selector(milestonesReceivedForAllProjects:milestoneKeys:projectKeys:)];

    projectCacheSetter = [[ProjectCacheSetter alloc] init];
    [[ProjectUpdatePublisher alloc]
        initWithListener:projectCacheSetter
        action:
        @selector(fetchedAllProjects:projectKeys:)];
        
    userCacheSetter = [[UserCacheSetter alloc] init];
    [[AllUserUpdatePublisher alloc]
        initWithListener:userCacheSetter
        action:@selector(fetchedAllUsers:)];
}

+ (void)loadSharedStatesFromPersistence
{
    MilestonePersistenceStore * milestonePersistenceStore =
        [[[MilestonePersistenceStore alloc] init] autorelease];
    MilestoneCache * milestoneCache =
        [milestonePersistenceStore
        loadFromPlist:[[self class] milestoneCachePlist]];
    [[self class] broadcastMilestoneCache:milestoneCache];

    ProjectPersistenceStore * projectPersistenceStore =
        [[[ProjectPersistenceStore alloc] init] autorelease];
    ProjectCache * projectCache =
        [projectPersistenceStore
        loadWithPlist:[[self class] projectCachePlist]];
    [[self class] broadcastProjectCache:projectCache];
    
    UserPersistenceStore * userPersistenceStore =
        [[[UserPersistenceStore alloc] init] autorelease];
    UserCache * userCache =
        [userPersistenceStore
        loadWithPlist:[[self class] userCachePlist]];
    [[self class] broadcastUserCache:userCache];
}

+ (void)broadcastProjectCache:(ProjectCache *)projectCache
{
    NSDictionary * projectDict = [projectCache allProjects];

    NSArray * projectKeys = [projectDict allKeys];
    NSMutableArray * projects = [NSMutableArray array];

    for (int i = 0; i < [projectKeys count]; i++) {
        id key = [projectKeys objectAtIndex:i];
        Project * project = [projectDict objectForKey:key];
        [projects insertObject:project atIndex:i];
    }

    // post general notification
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSDictionary * userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
        projects, @"projects",
        projectKeys, @"projectKeys",
        nil];
    NSString * notificationName =
        [LighthouseApiService allProjectsReceivedNotificationName];
    [nc postNotificationName:notificationName object:self userInfo:userInfo];
}

+ (void)broadcastMilestoneCache:(MilestoneCache *)milestoneCache
{
    NSDictionary * milestoneDict = [milestoneCache allMilestones];
    NSDictionary * projectKeyDict = [milestoneCache allProjectMappings];

    NSArray * milestoneIds = [milestoneDict allKeys];
    NSMutableArray * milestones = [NSMutableArray array];
    NSMutableArray * projectIds = [NSMutableArray array];

    for (int i = 0; i < [milestoneIds count]; i++) {
        id key = [milestoneIds objectAtIndex:i];
        Milestone * milestone = [milestoneDict objectForKey:key];
        id projectKey = [projectKeyDict objectForKey:key];
        [milestones insertObject:milestone atIndex:i];
        [projectIds insertObject:projectKey atIndex:i];
    }

    // post general notification
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSDictionary * userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
        milestones, @"milestones",
        milestoneIds, @"milestoneKeys",
        projectIds, @"projectKeys",
        nil];
    NSString * notificationName =
        [LighthouseApiService milestonesReceivedForAllProjectsNotificationName];
    [nc postNotificationName:notificationName object:self userInfo:userInfo];
}

+ (void)broadcastUserCache:(UserCache *)cache
{
    NSArray * userKeys = [[cache allUsers] allKeys];
    NSMutableArray * userArray = [NSMutableArray array];

    for (int i = 0; i < [userKeys count]; i++) {
        id key = [userKeys objectAtIndex:i];
        User * user = [cache userForKey:key];
        [userArray insertObject:user atIndex:i];
    }

    // post general notification
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSDictionary * userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
        userArray, @"users",
        userKeys, @"userKeys",
        nil];
    NSString * notificationName =
        [UserSetAggregator allUsersReceivedNotificationName];
    [nc postNotificationName:notificationName object:self
        userInfo:userInfo];
}

#pragma mark Ticket tab initialization

- (void)initTicketsTab
{
    TicketCache * ticketCache = [self loadTicketsFromPersistence];

    UIBarButtonItem * addButton =
        ticketsNetAwareViewController.navigationItem.rightBarButtonItem;
    UITextField * searchField =
        (UITextField *)
        ticketsNetAwareViewController.navigationItem.titleView;
    
    AccountLevelTicketBinDataSource * ticketBinDataSource = 
        [[[AccountLevelTicketBinDataSource alloc] init] autorelease];

    ticketDisplayMgr =
        [self createTicketDispMgr:ticketCache addButton:addButton
        searchField:searchField
        wrapperController:ticketsNetAwareViewController
        parentView:ticketsNetAwareViewController.navigationController.view
        ticketBinDataSource:ticketBinDataSource];
}

- (TicketDisplayMgr *)createTicketDispMgr:(TicketCache *)ticketCache
    addButton:(UIBarButtonItem *)addButton
    searchField:(UITextField *)searchField
    wrapperController:(NetworkAwareViewController *)wrapperController
    parentView:(UIView *)parentView ticketBinDataSource:(id)ticketBinDataSource
{
    TicketSearchMgr * ticketSearchMgr =
        [ticketSearchMgrFactory createTicketSearchMgrWithButton:addButton
        searchText:ticketCache.query searchField:searchField
        wrapperController:wrapperController parentView:parentView
        ticketBinDataSource:ticketBinDataSource];
    ((NSObject<TicketBinDataSourceProtocol> *)ticketBinDataSource).delegate =
        ticketSearchMgr;

    TicketDisplayMgr * aTicketDisplayMgr =
        [ticketDisplayMgrFactory createTicketDisplayMgrWithCache:ticketCache
        wrapperController:wrapperController ticketSearchMgr:ticketSearchMgr];
    addButton.target = aTicketDisplayMgr;
    addButton.action = @selector(addSelected);

    return aTicketDisplayMgr;
}

- (TicketCache *)loadTicketsFromPersistence
{
    NSLog(@"Loading ticket cache from persistence...");
    TicketPersistenceStore * ticketPersistenceStore =
        [[[TicketPersistenceStore alloc] init] autorelease];
    TicketCache * ticketCache =
        [ticketPersistenceStore loadWithPlist:[[self class] ticketCachePlist]];
    NSLog(@"Loaded ticket cache from persistence.");
    
    return ticketCache;
}

#pragma mark Project tab initialization

- (void)initProjectsTab
{
    TicketCache * ticketCache = [[[TicketCache alloc] init] autorelease];
    UIBarButtonItem * addButton =
        [[[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil
        action:nil]
        autorelease];
    UITextField * searchField = [[[UITextField alloc] init] autorelease];
    static const CGFloat FONT_SIZE = 17.0;
    searchField.font = [UIFont systemFontOfSize:FONT_SIZE];
    searchField.minimumFontSize = FONT_SIZE;
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.placeholder = @"Filter tickets";
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.returnKeyType = UIReturnKeyGo;
    searchField.contentVerticalAlignment =
        UIControlContentVerticalAlignmentCenter;

    NetworkAwareViewController * wrapperController =
        [[[NetworkAwareViewController alloc] init] autorelease];
    wrapperController.navigationItem.title = @"Tickets";
    wrapperController.navigationItem.titleView = searchField;

    UIView * parentView =
        projectsNetAwareViewController.navigationController.view;

    LighthouseApiService * ticketBinService =
        [lighthouseApiFactory createLighthouseApiService];
    TicketBinDataSource * ticketBinDataSource =
        [[TicketBinDataSource alloc] initWithService:ticketBinService];
    ticketBinService.delegate = ticketBinDataSource;

    projectLevelTicketDisplayMgr =
        [self createTicketDispMgr:ticketCache addButton:addButton
        searchField:searchField wrapperController:wrapperController
        parentView:parentView ticketBinDataSource:ticketBinDataSource];
    projectLevelTicketDisplayMgr.selectProject = NO;

    ProjectsViewController * projectsViewController =
        [[[ProjectsViewController alloc]
        initWithNibName:@"ProjectsView" bundle:nil] autorelease];
    projectsNetAwareViewController.targetViewController =
        projectsViewController;

    ProjectDisplayMgr * projectDisplayMgr =
        [[[ProjectDisplayMgr alloc]
        initWithProjectsViewController:projectsViewController
        networkAwareViewController:projectsNetAwareViewController
        ticketDisplayMgr:projectLevelTicketDisplayMgr] autorelease];
    projectsViewController.delegate = projectDisplayMgr;
    
    ProjectDispMgrProjectSetter * projectSetter =
        [[ProjectDispMgrProjectSetter alloc]
        initWithProjectDisplayMgr:projectDisplayMgr];
    [[ProjectUpdatePublisher alloc]
        initWithListener:projectSetter
        action:@selector(fetchedAllProjects:projectKeys:)];
}

#pragma mark Message tab initialization

- (void)initMessagesTab
{
    MessagesViewController * messagesViewController =
        [[MessagesViewController alloc]
        initWithNibName:@"MessagesView" bundle:nil];
    messagesNetAwareViewController.targetViewController =
        messagesViewController;

    MessageDisplayMgr * messageDisplayMgr =
        [[[MessageDisplayMgr alloc] initWithMessageCache:messageCache
        messageResponseCache:messageResponseCache
        networkAwareViewController:messagesNetAwareViewController
        messagesViewController:messagesViewController] autorelease];
    messagesViewController.delegate = messageDisplayMgr;
    messagesNetAwareViewController.delegate = messageDisplayMgr;
    
    UIBarButtonItem * addButton =
        messagesNetAwareViewController.navigationItem.rightBarButtonItem;
    addButton.target = messageDisplayMgr;
    addButton.action = @selector(createNewMessage);
}

#pragma mark News feed tabl initialization

- (void)initNewsFeedTab
{
    // Note: this instantiation/initialization is temporary
    LighthouseNewsFeedService * newsFeedService =
        [[[LighthouseNewsFeedService alloc] initWithBaseUrlString:
        @"http://highorderbit.lighthouseapp.com/events.atom"] autorelease];
    NewsFeedPersistenceStore * newsFeedPersistenceStore =
        [[[NewsFeedPersistenceStore alloc] init] autorelease];
    NSArray * newsItemCache =
        [newsFeedPersistenceStore
        loadWithPlist:[[self class] newsFeedCachePlist]];
    newsFeedDataSource =
        [[NewsFeedDataSource alloc]
        initWithNewsFeedService:newsFeedService cache:newsItemCache];

    newsFeedDisplayMgr =
        [[NewsFeedDisplayMgr alloc]
        initWithNetworkAwareViewController:newsFeedNetworkAwareViewController
                        newsFeedDataSource:newsFeedDataSource];
}

#pragma mark Message tab initialization

- (void)initMilestonesTab
{
    MilestoneCache * milestoneCache =
        [[[MilestoneCache alloc] init] autorelease];

    LighthouseApiService * milestoneDetailsService =
        [lighthouseApiFactory createLighthouseApiService];

    MilestoneDetailsDataSource * milestoneDetailsDataSource =
        [[[MilestoneDetailsDataSource alloc]
        initWithLighthouseApiService:milestoneDetailsService
                         ticketCache:ticketDisplayMgr.ticketCache
                      milestoneCache:milestoneCache] autorelease];
    MilestoneDetailsDisplayMgr * milestoneDetailsDisplayMgr =
        [[[MilestoneDetailsDisplayMgr alloc]
        initWithMilestoneDetailsDataSource:milestoneDetailsDataSource]
        autorelease];

    LighthouseApiService * milestoneService =
        [lighthouseApiFactory createLighthouseApiService];
    MilestoneDataSource * milestoneDataSource =
        [[[MilestoneDataSource alloc]
        initWithLighthouseApiService:milestoneService
                      milestoneCache:milestoneCache] autorelease];
    milestoneDisplayMgr =
        [[MilestoneDisplayMgr alloc]
        initWithNetworkAwareViewController:milestonesNetworkAwareViewController
        milestoneDataSource:milestoneDataSource
        milestoneDetailsDisplayMgr:milestoneDetailsDisplayMgr];
}

#pragma mark String constants

+ (NSString *)newsFeedCachePlist
{
    return @"NewsFeedCache";
}

+ (NSString *)ticketCachePlist
{
    return @"TicketCache";
}

+ (NSString *)projectCachePlist
{
    return @"ProjectCache";
}

+ (NSString *)milestoneCachePlist
{
    return @"MilestoneCache";
}

+ (NSString *)userCachePlist
{
    return @"UserCache";
}

@end
