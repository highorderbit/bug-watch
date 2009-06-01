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
#import "NewsFeedDataSource.h"

@class NetworkAwareViewController;
@class NewsFeedDisplayMgr, MilestoneDisplayMgr;
@class MilestoneCache;

@interface BugWatchAppController : NSObject
{
    IBOutlet NetworkAwareViewController * newsFeedNetworkAwareViewController;
    IBOutlet NetworkAwareViewController * ticketsNetAwareViewController;
    IBOutlet ProjectsViewController * projectsViewController;
    IBOutlet NetworkAwareViewController * milestonesNetworkAwareViewController;
    IBOutlet NetworkAwareViewController * messagesNetAwareViewController;
    IBOutlet UIViewController * pagesViewController;
    IBOutlet UITabBarController * tabBarController;

    TicketDisplayMgr * ticketDisplayMgr;
    MessageCache * messageCache;
    MessageResponseCache * messageResponseCache;
    MilestoneCache * milestoneCache;

    NewsFeedDisplayMgr * newsFeedDisplayMgr;
    NewsFeedDataSource * newsFeedDataSource;
    MilestoneDisplayMgr * milestoneDisplayMgr;
}

- (void)start;
- (void)persistState;

@end
