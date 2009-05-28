//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"
#import "NetworkAwareViewController.h"
#import "TicketDetailsViewController.h"
#import "NewsFeedDisplayMgr.h"
#import "NewsFeedDataSource.h"
#import "NewsFeedViewController.h"
#import "LighthouseNewsFeedService.h"
#import "NetworkAwareViewController.h"
#import "TicketComment.h"
#import "MilestoneCache.h"
#import "MilestoneDisplayMgr.h"
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
#import "TicketBinViewController.h"
#import "TicketBinDataSource.h"
#import "AccountLevelTicketBinDataSource.h"
#import "TicketPersistenceStore.h"
#import "MilestoneUpdatePublisher.h"
#import "TicketDispMgrMilestoneSetter.h"
#import "UIStatePersistenceStore.h"
#import "UIState.h"
#import "TicketDispMgrProjectSetter.h"
#import "ProjectUpdatePublisher.h"
#import "UserSetAggregator.h"
#import "TicketDispMgrUserSetter.h"

@interface BugWatchAppController (Private)

- (void)initTicketsTab;
- (TicketCache *)loadTicketsFromPersistence;
- (TicketSearchMgr *)initTicketSearchMgrWithButton:(UIBarButtonItem *)addButton
    searchText:(NSString *)searchText;
- (TicketBinDataSource *)initTicketBinDataSource;

- (void)initProjectsTab;
- (void)initMessagesTab;
- (void)initMilestonesTab;

+ (LighthouseApiService *)createLighthouseApiService;
+ (NSString *)ticketCachePlist;

@end

@implementation BugWatchAppController

- (void)dealloc
{
    [newsFeedNetworkAwareViewController release];
    [ticketsNetAwareViewController release];
    [projectsViewController release];
    [milestonesNetworkAwareViewController release];
    [messagesNetAwareViewController release];
    [pagesViewController release];

    [ticketDisplayMgr release];
    [messageCache release];
    [messageResponseCache release];
    [milestoneCache release];

    [newsFeedDisplayMgr release];
    [milestoneDisplayMgr release];

    [super dealloc];
}

#pragma mark Public interface implementation

- (void)start
{
    messageCache = [[MessageCache alloc] init];
    messageResponseCache = [[MessageResponseCache alloc] init];
    
    // TODO: read milestones, users, projects from persistence store

    // load single-session, global data (milestones, projects, users)
    NSString * baseServiceUrl = @"https://highorderbit.lighthouseapp.com/"; // TEMPORARY
    LighthouseApiService * service =
        [[LighthouseApiService alloc]
        initWithBaseUrlString:baseServiceUrl];

    NSString * token = @"6998f7ed27ced7a323b256d83bd7fec98167b1b3"; // TEMPORARY
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

    // Note: this instantiation/initialization is temporary
    LighthouseNewsFeedService * newsFeedService =
        [[[LighthouseNewsFeedService alloc] initWithBaseUrlString:
        @"http://highorderbit.lighthouseapp.com/events.atom"] autorelease];
    NewsFeedDataSource * newsFeedDataSource =
        [[[NewsFeedDataSource alloc]
        initWithNewsFeedService:newsFeedService] autorelease];

    newsFeedDisplayMgr =
        [[NewsFeedDisplayMgr alloc]
        initWithNetworkAwareViewController:newsFeedNetworkAwareViewController
                        newsFeedDataSource:newsFeedDataSource];

    [self initMilestonesTab];

    UIStatePersistenceStore * uiStatePersistenceStore =
        [[[UIStatePersistenceStore alloc] init] autorelease];
    UIState * uiState = [uiStatePersistenceStore load];
    tabBarController.selectedIndex = uiState.selectedTab;
}

- (void)persistState
{
    NSLog(@"Persisting state...");
    TicketCache * ticketCache = ticketDisplayMgr.ticketCache;
    TicketPersistenceStore * ticketPersistenceStore =
        [[[TicketPersistenceStore alloc] init] autorelease];
    [ticketPersistenceStore saveTicketCache:ticketCache
        toPlist:[[self class] ticketCachePlist]];
        
    UIStatePersistenceStore * uiStatePersistenceStore =
        [[[UIStatePersistenceStore alloc] init] autorelease];
    UIState * uiState = [[[UIState alloc] init] autorelease];
    uiState.selectedTab = tabBarController.selectedIndex;
    [uiStatePersistenceStore save:uiState];
}

#pragma mark Ticket tab initialization

- (void)initTicketsTab
{
    TicketCache * ticketCache = [self loadTicketsFromPersistence];

    UIBarButtonItem * addButton =
        ticketsNetAwareViewController.navigationItem.rightBarButtonItem;
    TicketSearchMgr * ticketSearchMgr =
        [self initTicketSearchMgrWithButton:addButton
        searchText:ticketCache.query];

    TicketsViewController * ticketsViewController =
        [[[TicketsViewController alloc]
        initWithNibName:@"TicketsView" bundle:nil] autorelease];
    ticketsNetAwareViewController.targetViewController = ticketsViewController;
    
    LighthouseApiService * ticketLighthouseApiService =
        [[self class] createLighthouseApiService];

    TicketDataSource * ticketDataSource =
        [[[TicketDataSource alloc] initWithService:ticketLighthouseApiService]
        autorelease];
    ticketLighthouseApiService.delegate = ticketDataSource;
    
    ticketDisplayMgr =
        [[[TicketDisplayMgr alloc] initWithTicketCache:ticketCache
        networkAwareViewController:ticketsNetAwareViewController
        ticketsViewController:ticketsViewController
        dataSource:ticketDataSource] autorelease];
    ticketsViewController.delegate = ticketDisplayMgr;
    ticketsNetAwareViewController.delegate = ticketDisplayMgr;
    ticketDataSource.delegate = ticketDisplayMgr;
    ticketSearchMgr.delegate = ticketDisplayMgr;
    addButton.target = ticketDisplayMgr;
    addButton.action = @selector(addSelected);
    
    // intentionally not autoreleasing either of the following objects
    TicketDispMgrMilestoneSetter * milestoneSetter =
        [[TicketDispMgrMilestoneSetter alloc]
        initWithTicketDisplayMgr:ticketDisplayMgr];
    // just create, no need to assign a variable
    [[MilestoneUpdatePublisher alloc]
        initWithListener:milestoneSetter
        action:
        @selector(milestonesReceivedForAllProjects:milestoneKeys:projectKeys:)];

    // intentionally not autoreleasing either of the following objects
    TicketDispMgrProjectSetter * projectSetter =
        [[TicketDispMgrProjectSetter alloc]
        initWithTicketDisplayMgr:ticketDisplayMgr];
    // just create, no need to assign a variable
    [[ProjectUpdatePublisher alloc]
        initWithListener:projectSetter
        action:@selector(fetchedAllProjects:projectKeys:)];
        
    TicketDispMgrUserSetter * userSetter =
        [[[TicketDispMgrUserSetter alloc]
        initWithTicketDisplayMgr:ticketDisplayMgr] autorelease];
    LighthouseApiService * userSetterService =
        [[self class] createLighthouseApiService];
    UserSetAggregator * userSetAggregator =
           [[UserSetAggregator alloc]
           initWithListener:userSetter action:@selector(fetchedAllUsers:)
           apiService:userSetterService token:@"6998f7ed27ced7a323b256d83bd7fec98167b1b3" /* TEMPORARY */];
   userSetterService.delegate = userSetAggregator;
    [[ProjectUpdatePublisher alloc]
        initWithListener:userSetAggregator
        action:@selector(fetchedAllProjects:projectKeys:)];
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

- (TicketSearchMgr *)initTicketSearchMgrWithButton:(UIBarButtonItem *)addButton
    searchText:(NSString *)searchText
{
    UITextField * searchField =
        (UITextField *)ticketsNetAwareViewController.navigationItem.titleView;
    searchField.text = searchText;

    TicketBinViewController * binViewController =
        [[[TicketBinViewController alloc]
        initWithNibName:@"TicketBinView" bundle:nil] autorelease];
    AccountLevelTicketBinDataSource * ticketBinDataSource = 
        [[[AccountLevelTicketBinDataSource alloc] init] autorelease];

    TicketSearchMgr * ticketSearchMgr =
        [[TicketSearchMgr alloc]
        initWithSearchField:searchField addButton:addButton
        navigationItem:ticketsNetAwareViewController.navigationItem
        ticketBinViewController:binViewController
        parentView:ticketsNetAwareViewController.navigationController.view
        dataSourceTarget:ticketBinDataSource
        dataSourceAction:@selector(fetchAllTicketBins)];
    ticketBinDataSource.delegate = ticketSearchMgr;
    binViewController.delegate = ticketSearchMgr;
    // this won't get dealloced, but fine since it exists for the runtime
    // lifetime

    return ticketSearchMgr;
}

- (TicketBinDataSource *)initTicketBinDataSource
{
    LighthouseApiService * ticketBinLighthouseApiService =
        [[self class] createLighthouseApiService];
    TicketBinDataSource * ticketBinDataSource =
        [[[TicketBinDataSource alloc]
        initWithService:ticketBinLighthouseApiService]
        autorelease];
    ticketBinLighthouseApiService.delegate = ticketBinDataSource;

    return ticketBinDataSource;
}

#pragma mark Project tab initialization

- (void)initProjectsTab
{
    ProjectDisplayMgr * projectDisplayMgr =
        [[[ProjectDisplayMgr alloc] initWithProjectCache:nil
        projectsViewController:projectsViewController] autorelease];
    projectsViewController.delegate = projectDisplayMgr;
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

#pragma mark Message tab initialization

- (void)initMilestonesTab
{
    milestoneCache = [[MilestoneCache alloc] init];

    LighthouseApiService * milestoneDetailsService =
        [[self class] createLighthouseApiService];

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
        [[self class] createLighthouseApiService];
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

#pragma mark Static factory methods

+ (LighthouseApiService *)createLighthouseApiService
{
    return [[[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"]
        autorelease];
}

#pragma mark String constants

+ (NSString *)ticketCachePlist
{
    return @"TicketCache";
}

@end
