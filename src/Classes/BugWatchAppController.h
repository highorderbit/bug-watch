//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketsViewController.h"
#import "TicketCache.h"
#import "TicketDisplayMgr.h"

@class NetworkAwareViewController;
@class NewsFeedDisplayMgr, MilestoneDisplayMgr;

@interface BugWatchAppController : NSObject
{
    IBOutlet NetworkAwareViewController * newsFeedNetworkAwareViewController;

    IBOutlet TicketsViewController * ticketsViewController;
    IBOutlet UINavigationController * ticketsNavController;

    IBOutlet UIViewController * projectsViewController;
    IBOutlet UINavigationController * projectsNavController;

    IBOutlet NetworkAwareViewController * milestonesNetworkAwareViewController;

    IBOutlet UIViewController * messagesViewController;
    IBOutlet UINavigationController * messagesNavController;

    IBOutlet UIViewController * pagesViewController;
    IBOutlet UINavigationController * pagesNavController;

    TicketCache * ticketCache;

    NewsFeedDisplayMgr * newsFeedDisplayMgr;
    MilestoneDisplayMgr * milestoneDisplayMgr;
}

- (void)start;

@end
