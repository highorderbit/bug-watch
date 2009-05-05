//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"
#import "TicketDetailsViewController.h"
#import "NewsFeedDisplayMgr.h"
#import "NewsFeedDataSource.h"
#import "NewsFeedViewController.h"
#import "LighthouseNewsFeedService.h"
#import "NetworkAwareViewController.h"
#import "TicketComment.h"

@implementation BugWatchAppController

- (void)dealloc
{
    [newsFeedNetworkAwareViewController release];
    [newsFeedNetworkAwareViewController release];

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
    NSString * description1 =
        @"If timing is just right, updating view can be added to wrong view controller when backing out of drill-down";
    NSString * message1 =
        @"The 'Next' button is enabled even when a username hasn't been supplied. Should it be? Is it important? The 'Done' button sends the request when both fields are blank and the second field is selected even though 'Add' is disabled.\n\nOne difference between the repo favorites add view and the log in view is that the log in view sends the request while the repo view just hides the keyboard in the above scenario. Not sure which is better or what the solution should be yet.";
    NSMutableArray * comments = [NSMutableArray array];
    TicketComment * comment1 =
        [[[TicketComment alloc]
        initWithStateChangeDescription:@"State changed from 'new' to 'resolved'"
        text:@"Changed the log in view and the repo view to behave the same way: if valid input has not been provided, hitting the return key on the second text field does nothing."
        date:[NSDate date]] autorelease];
    TicketComment * comment2 =
        [[[TicketComment alloc]
        initWithStateChangeDescription:@"State changed from 'new' to 'hold'"
        text:@"blah blah blah" date:[NSDate date]] autorelease];
    [comments addObject:comment1];
    [comments addObject:comment2];

    Ticket * ticket1 =
        [[[Ticket alloc] initWithDescription:description1 message:message1
        creationDate:[NSDate date]] autorelease];
    TicketMetaData * metaData1 =
        [[TicketMetaData alloc] initWithTags:@"bug ui" state:kNew
        lastModifiedDate:[NSDate date]];
        
    NSString * description2 = @"Really short description";
    Ticket * ticket2 =
        [[[Ticket alloc] initWithDescription:description2 message:@""
        creationDate:[NSDate date]] autorelease];
    TicketMetaData * metaData2 =
        [[TicketMetaData alloc] initWithTags:@"" state:kResolved
        lastModifiedDate:[NSDate date]];

    NSString * description3 = @"Support followed users in GitHub service";
    NSString * message3 = @"Steps to reproduce:\nFrom a user's page, tap one of their repositories that is not cached.\nQuickly return to the user page.\nTap a different repo.\nIt's possible that the first repo will load.";
    Ticket * ticket3 =
        [[[Ticket alloc] initWithDescription:description3 message:message3
        creationDate:[NSDate date]] autorelease];
    TicketMetaData * metaData3 =
        [[TicketMetaData alloc] initWithTags:@"bug" state:kHold
        lastModifiedDate:[NSDate date]];

    [ticketCache setTicket:ticket1 forNumber:213];
    [ticketCache setTicket:ticket2 forNumber:56];
    [ticketCache setTicket:ticket3 forNumber:217];
    
    [ticketCache setMetaData:metaData1 forNumber:213];
    [ticketCache setMetaData:metaData2 forNumber:56];
    [ticketCache setMetaData:metaData3 forNumber:217];
    
    [ticketCache setAssignedToKey:[NSNumber numberWithInt:0] forNumber:213];
    [ticketCache setAssignedToKey:[NSNumber numberWithInt:1] forNumber:56];
    [ticketCache setAssignedToKey:[NSNumber numberWithInt:0] forNumber:217];

    [ticketCache setCreatedByKey:[NSNumber numberWithInt:0] forNumber:213];
    [ticketCache setCreatedByKey:[NSNumber numberWithInt:0] forNumber:56];
    [ticketCache setCreatedByKey:[NSNumber numberWithInt:1] forNumber:217];

    [ticketCache setMilestoneKey:[NSNumber numberWithInt:0] forNumber:213];
    [ticketCache setMilestoneKey:[NSNumber numberWithInt:1] forNumber:56];
    [ticketCache setMilestoneKey:[NSNumber numberWithInt:1] forNumber:217];
    // TEMPORARY

    TicketDisplayMgr * ticketDisplayMgr =
        [[TicketDisplayMgr alloc] initWithTicketCache:ticketCache
        navigationController:ticketsNavController
        ticketsViewController:ticketsViewController];
    ticketsViewController.delegate = ticketDisplayMgr;

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
}

@end