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
#import "TicketPersistenceStore.h"

@interface BugWatchAppController (Private)

- (void)initTicketsTab;
- (void)initProjectsTab;
- (void)initMessagesTab;
- (void)initMilestonesTab;

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

- (void)start
{
    messageCache = [[MessageCache alloc] init];
    messageResponseCache = [[MessageResponseCache alloc] init];
    
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
}

- (void)persistState
{
    NSLog(@"Persisting state...");
    TicketCache * ticketCache = ticketDisplayMgr.ticketCache;
    TicketPersistenceStore * ticketPersistenceStore =
        [[[TicketPersistenceStore alloc] init] autorelease];
    [ticketPersistenceStore saveTicketCache:ticketCache
        toPlist:[[self class] ticketCachePlist]];
}

- (void)initTicketsTab
{
    NSLog(@"Loading ticket cache from persistence...");
    TicketPersistenceStore * ticketPersistenceStore =
        [[[TicketPersistenceStore alloc] init] autorelease];
    TicketCache * ticketCache =
        [ticketPersistenceStore loadWithPlist:[[self class] ticketCachePlist]];
    NSLog(@"Loaded ticket cache from persistence.");

    UIBarButtonItem * cancelButton =
        ticketsNetAwareViewController.navigationItem.leftBarButtonItem;
    UIBarButtonItem * addButton =
        ticketsNetAwareViewController.navigationItem.rightBarButtonItem;
    UITextField * searchField =
        (UITextField *)ticketsNetAwareViewController.navigationItem.titleView;
    TicketBinViewController * binViewController =
        [[[TicketBinViewController alloc]
        initWithNibName:@"TicketBinView" bundle:nil] autorelease];

    TicketsViewController * ticketsViewController =
        [[[TicketsViewController alloc]
        initWithNibName:@"TicketsView" bundle:nil] autorelease];
    ticketsNetAwareViewController.targetViewController = ticketsViewController;

    LighthouseApiService * ticketBinLighthouseApiService =
        [[[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"]
        autorelease];
    TicketBinDataSource * ticketBinDataSource =
        [[[TicketBinDataSource alloc]
        initWithService:ticketBinLighthouseApiService]
        autorelease];
    ticketBinLighthouseApiService.delegate = ticketBinDataSource;

    TicketSearchMgr * ticketSearchMgr =
        [[TicketSearchMgr alloc]
        initWithSearchField:searchField addButton:addButton
        cancelButton:cancelButton
        navigationItem:ticketsNetAwareViewController.navigationItem
        ticketBinViewController:binViewController
        parentView:ticketsNetAwareViewController.navigationController.view
        dataSource:ticketBinDataSource];
    ticketBinDataSource.delegate = ticketSearchMgr;
    binViewController.delegate = ticketSearchMgr;
    // this won't get dealloced, but fine since it exists for the runtime
    // lifetime
    
    LighthouseApiService * ticketLighthouseApiService =
        [[[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"]
        autorelease];

    TicketDataSource * ticketDataSource =
        [[[TicketDataSource alloc] initWithService:ticketLighthouseApiService]
        autorelease];
    ticketLighthouseApiService.delegate = ticketDataSource;
    
    ticketDisplayMgr =
        [[[TicketDisplayMgr alloc] initWithTicketCache:ticketCache
        initialFilterString:nil
        networkAwareViewController:ticketsNetAwareViewController
        ticketsViewController:ticketsViewController
        dataSource:ticketDataSource] autorelease];
    ticketsViewController.delegate = ticketDisplayMgr;
    ticketsNetAwareViewController.delegate = ticketDisplayMgr;
    ticketDataSource.delegate = ticketDisplayMgr;
    ticketSearchMgr.delegate = ticketDisplayMgr;
    addButton.target = ticketDisplayMgr;
    addButton.action = @selector(addSelected);
}

- (void)initProjectsTab
{
    ProjectDisplayMgr * projectDisplayMgr =
        [[[ProjectDisplayMgr alloc] initWithProjectCache:nil
        projectsViewController:projectsViewController] autorelease];
    projectsViewController.delegate = projectDisplayMgr;
}

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

- (void)initMilestonesTab
{
    milestoneCache = [[MilestoneCache alloc] init];

    LighthouseApiService * milestoneDetailsService =
        [[[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"]
        autorelease];
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
        [[[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"]
        autorelease];
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

+ (NSString *)ticketCachePlist
{
    return @"TicketCache";
}

@end
