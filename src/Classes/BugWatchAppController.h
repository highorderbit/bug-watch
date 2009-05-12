//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketCache.h"
#import "TicketDisplayMgr.h"
#import "ProjectsViewController.h"
#import "MessageCache.h"
#import "MessagesViewController.h"
#import "MessageResponseCache.h"

@class NetworkAwareViewController;
@class NewsFeedDisplayMgr, MilestoneDisplayMgr;

@interface BugWatchAppController : NSObject
{
    IBOutlet NetworkAwareViewController * newsFeedNetworkAwareViewController;
    IBOutlet NetworkAwareViewController * ticketsNetAwareViewController;
    IBOutlet ProjectsViewController * projectsViewController;
    IBOutlet NetworkAwareViewController * milestonesNetworkAwareViewController;
    IBOutlet NetworkAwareViewController * messagesNetAwareViewController;
    IBOutlet UIViewController * pagesViewController;

    TicketCache * ticketCache;
    MessageCache * messageCache;
    MessageResponseCache * messageResponseCache;

    NewsFeedDisplayMgr * newsFeedDisplayMgr;
    MilestoneDisplayMgr * milestoneDisplayMgr;
}

- (void)start;

@end
