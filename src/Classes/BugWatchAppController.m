//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"
#import "TicketDetailsViewController.h"
#import "NewsFeedDisplayMgr.h"
#import "NewsFeedDataSource.h"
#import "LighthouseNewsFeedService.h"

@implementation BugWatchAppController

- (void)dealloc
{
    [newsFeedViewController release];
    [newsFeedNavController release];

    [ticketsViewController release];
    [ticketsNavController release];

    [projectsViewController release];
    [projectsNavController release];

    [milestonesViewController release];
    [milestonesNavController release];

    [messagesViewController release];
    [messagesNavController release];

    [pagesViewController release];
    [pagesNavController release];

    [ticketCache release];

    [newsFeedDisplayMgr release];

    [super dealloc];
}

- (void)start
{
    ticketCache = [[TicketCache alloc] init];

    // TEMPORARY
    NSString * description1 = @"If timing is just right, updating view can be added to wrong view controller when backing out of drill-down";
    Ticket * ticket1 =
        [[Ticket alloc] initWithDescription:description1
        state:(NSUInteger)kNew creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    NSString * description2 = @"Add disclosure indicators to news feed";
    Ticket * ticket2 =
        [[Ticket alloc] initWithDescription:description2
        state:(NSUInteger)kResolved creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    NSString * description3 = @"Support followed users in GitHub service";
    Ticket * ticket3 =
        [[Ticket alloc] initWithDescription:description3
        state:(NSUInteger)kHold creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    NSString * description4 = @"Keypad 'done' button incorrectly enabled on log in and favorites";
    Ticket * ticket4 =
        [[Ticket alloc] initWithDescription:description4
        state:(NSUInteger)kResolved creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    [ticketCache setTicket:ticket1 forNumber:213];
    [ticketCache setTicket:ticket2 forNumber:56];
    [ticketCache setTicket:ticket3 forNumber:217];
    [ticketCache setTicket:ticket4 forNumber:4];
    // TEMPORARY

    TicketSelectionMgr * ticketSelectionMgr =
        [[TicketSelectionMgr alloc] initWithTicketCache:ticketCache
        navigationController:ticketsNavController
        ticketsViewController:ticketsViewController];
    ticketsViewController.delegate = ticketSelectionMgr;

    // Note: this instantiation/initialization is temporary
    LighthouseNewsFeedService * newsFeedService =
        [[[LighthouseNewsFeedService alloc] initWithBaseUrlString:
        @"http://highorderbit.lighthouseapp.com/events.atom"] autorelease];
    NewsFeedDataSource * newsFeedDataSource =
        [[[NewsFeedDataSource alloc]
        initWithNewsFeedService:newsFeedService] autorelease];

    newsFeedDisplayMgr =
        [[NewsFeedDisplayMgr alloc]
        initWithNewsFeedViewController:newsFeedViewController
                    newsFeedDataSource:newsFeedDataSource];
}

@end
