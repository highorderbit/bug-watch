//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDisplayMgrFactory.h"
#import "TicketDispMgrProjectSetter.h"
#import "TicketDispMgrMilestoneSetter.h"
#import "TicketDispMgrUserSetter.h"
#import "ProjectUpdatePublisher.h"
#import "AllUserUpdatePublisher.h"
#import "MilestoneUpdatePublisher.h"
#import "UserSetAggregator.h"

@interface TicketDisplayMgrFactory (Private)

- (void)initProjectSetterForTicketDispMgr:(TicketDisplayMgr *)ticketDispMgr;
- (void)initMilestoneSetterForTicketDispMgr:(TicketDisplayMgr *)ticketDispMgr;
- (void)initUserSetterForTicketDispMgr:(TicketDisplayMgr *)ticketDispMgr;

@end

@implementation TicketDisplayMgrFactory

- (void)dealloc
{
    [lighthouseApiFactory release];
    [super dealloc];
}

- (id)initWithLighthouseApiFactory:
    (LighthouseApiServiceFactory *)aLighthouseApiFactory
{
    if (self = [super init])
        lighthouseApiFactory = [aLighthouseApiFactory retain];

    return self;
}

- (TicketDisplayMgr *)createTicketDisplayMgrWithCache:(TicketCache *)ticketCache
    wrapperController:(NetworkAwareViewController *)wrapperController
    ticketSearchMgr:(TicketSearchMgr *)ticketSearchMgr
{
    TicketsViewController * ticketsViewController =
        [[[TicketsViewController alloc]
        initWithNibName:@"TicketsView" bundle:nil] autorelease];
    wrapperController.targetViewController = ticketsViewController;

    LighthouseApiService * ticketLighthouseApiService =
        [lighthouseApiFactory createLighthouseApiService];

    TicketDataSource * ticketDataSource =
        [[[TicketDataSource alloc] initWithService:ticketLighthouseApiService]
        autorelease];
    ticketLighthouseApiService.delegate = ticketDataSource;

    TicketDisplayMgr * ticketDisplayMgr =
        [[[TicketDisplayMgr alloc] initWithTicketCache:ticketCache
        networkAwareViewController:wrapperController
        ticketsViewController:ticketsViewController
        dataSource:ticketDataSource] autorelease];
    ticketsViewController.delegate = ticketDisplayMgr;
    wrapperController.delegate = ticketDisplayMgr;
    ticketDataSource.delegate = ticketDisplayMgr;
    ticketSearchMgr.delegate = ticketDisplayMgr;

    [self initProjectSetterForTicketDispMgr:ticketDisplayMgr];
    [self initMilestoneSetterForTicketDispMgr:ticketDisplayMgr];
    [self initUserSetterForTicketDispMgr:ticketDisplayMgr];
    
    return ticketDisplayMgr;
}

- (void)initProjectSetterForTicketDispMgr:(TicketDisplayMgr *)ticketDispMgr
{
    // intentionally not autoreleasing either of the following objects
    TicketDispMgrProjectSetter * projectSetter =
        [[TicketDispMgrProjectSetter alloc]
        initWithTicketDisplayMgr:ticketDispMgr];
    // just create, no need to assign a variable
    [[ProjectUpdatePublisher alloc]
        initWithListener:projectSetter
        action:@selector(fetchedAllProjects:projectKeys:)];
}

- (void)initMilestoneSetterForTicketDispMgr:(TicketDisplayMgr *)ticketDispMgr
{
    // intentionally not autoreleasing either of the following objects
    TicketDispMgrMilestoneSetter * milestoneSetter =
        [[TicketDispMgrMilestoneSetter alloc]
        initWithTicketDisplayMgr:ticketDispMgr];
    // just create, no need to assign a variable
    [[MilestoneUpdatePublisher alloc]
        initWithListener:milestoneSetter
        action:
        @selector(milestonesReceivedForAllProjects:milestoneKeys:projectKeys:)];
}

- (void)initUserSetterForTicketDispMgr:(TicketDisplayMgr *)ticketDispMgr
{
    TicketDispMgrUserSetter * userSetter =
        [[TicketDispMgrUserSetter alloc]
        initWithTicketDisplayMgr:ticketDispMgr];
    LighthouseApiService * userSetterService =
        [lighthouseApiFactory createLighthouseApiService];
    UserSetAggregator * userSetAggregator =
        [[UserSetAggregator alloc] initWithApiService:userSetterService];
    [[AllUserUpdatePublisher alloc]
        initWithListener:userSetter
        action:@selector(fetchedAllUsers:)];

    userSetterService.delegate = userSetAggregator;
    [[ProjectUpdatePublisher alloc]
        initWithListener:userSetAggregator
        action:@selector(fetchedAllProjects:projectKeys:)];
}

@end
