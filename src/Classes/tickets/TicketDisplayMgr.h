//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketsViewControllerDelegate.h"
#import "TicketDetailsViewControllerDelegate.h"
#import "TicketCache.h"
#import "TicketsViewController.h"
#import "TicketDetailsViewController.h"
#import "EditTicketViewController.h"
#import "NetworkAwareViewController.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "TicketDataSource.h"
#import "TicketDataSourceDelegate.h"
#import "TicketSearchMgrDelegate.h"
#import "TicketCommentCache.h"
#import "ProjectSelectionViewController.h"
#import "RecentHistoryCache.h"

@interface TicketDisplayMgr :
    NSObject <TicketsViewControllerDelegate,
    TicketDetailsViewControllerDelegate, NetworkAwareViewControllerDelegate,
    TicketDataSourceDelegate, TicketSearchMgrDelegate>
{
    id selectedTicketKey;

    TicketCache * ticketCache;
    RecentHistoryCache * recentHistoryCommentCache;

    NetworkAwareViewController * wrapperController;
    TicketsViewController * ticketsViewController;
    TicketDataSource * dataSource;
    TicketDetailsViewController * detailsViewController;
    NetworkAwareViewController * detailsNetAwareViewController;
    EditTicketViewController * editTicketViewController;
    ProjectSelectionViewController * projectSelectionViewController;

    NSDictionary * userDict;
    NSDictionary * milestoneDict;
    NSDictionary * milestoneToProjectDict;
    NSDictionary * projectDict;

    UIView * darkTransparentView;
    UILabel * loadingLabel;

    id activeProjectKey;
    BOOL selectProject;
    BOOL firstTimeDisplayed;
}

@property (readonly) NetworkAwareViewController * wrapperController;
@property (readonly) TicketsViewController * ticketsViewController;
@property (readonly) TicketDetailsViewController * detailsViewController;
@property (readonly) NetworkAwareViewController * detailsNetAwareViewController;
@property (readonly) EditTicketViewController * editTicketViewController;
@property (readonly)
    ProjectSelectionViewController * projectSelectionViewController;
@property (readonly) UINavigationController * navController;

@property (nonatomic, retain) TicketCache * ticketCache;
@property (nonatomic, retain) RecentHistoryCache * recentHistoryCommentCache;
@property (nonatomic, copy) id activeProjectKey;
@property (nonatomic, assign) BOOL selectProject;

@property (nonatomic, copy) NSDictionary * milestoneDict;
@property (nonatomic, copy) NSDictionary * milestoneToProjectDict;
@property (nonatomic, copy) NSDictionary * projectDict;
@property (nonatomic, copy) NSDictionary * userDict;

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    networkAwareViewController:(NetworkAwareViewController *)wrapperController
    ticketsViewController:(TicketsViewController *)aTicketsViewController
    dataSource:(TicketDataSource *)aDataSource;
    
- (void)addSelected;

@end
