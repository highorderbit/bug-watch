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

@interface TicketDisplayMgr :
    NSObject <TicketsViewControllerDelegate,
    TicketDetailsViewControllerDelegate>
{
    NSUInteger selectedTicketNumber;
    TicketCache * ticketCache;
    UINavigationController * navController;
    TicketsViewController * ticketsViewController;
    TicketDetailsViewController * detailsViewController;
    EditTicketViewController * editTicketViewController;
    
    // TEMPORARY
    NSMutableDictionary * userDict;
    NSMutableDictionary * milestoneDict;
    // TEMPORARY
}

@property (readonly) TicketDetailsViewController * detailsViewController;
@property (readonly) EditTicketViewController * editTicketViewController;

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    navigationController:(UINavigationController *)aNavController
    ticketsViewController:(TicketsViewController *)aTicketsViewController;

@end
