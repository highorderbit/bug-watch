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

@interface TicketDisplayMgr :
    NSObject <TicketsViewControllerDelegate,
    TicketDetailsViewControllerDelegate, NetworkAwareViewControllerDelegate,
    TicketDataSourceDelegate, TicketSearchMgrDelegate>
{
    NSString * filterString;
    id selectedTicketKey;

    TicketCache * ticketCache;
    TicketCommentCache * commentCache;
    
    NetworkAwareViewController * wrapperController;
    TicketsViewController * ticketsViewController;
    TicketDataSource * dataSource;
    TicketDetailsViewController * detailsViewController;
    NetworkAwareViewController * detailsNetAwareViewController;
    EditTicketViewController * editTicketViewController;

    // TEMPORARY
    NSMutableDictionary * userDict;
    NSMutableDictionary * milestoneDict;
    // TEMPORARY
}

@property (readonly) TicketDetailsViewController * detailsViewController;
@property (readonly) NetworkAwareViewController * detailsNetAwareViewController;
@property (readonly) EditTicketViewController * editTicketViewController;
@property (readonly) UINavigationController * navController;

@property (nonatomic, retain) TicketCache * ticketCache;
@property (nonatomic, copy) NSString * filterString;

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    initialFilterString:(NSString *)initialFilterString
    networkAwareViewController:(NetworkAwareViewController *)wrapperController
    ticketsViewController:(TicketsViewController *)aTicketsViewController
    dataSource:(TicketDataSource *)aDataSource;
    
- (void)addSelected;

@end
