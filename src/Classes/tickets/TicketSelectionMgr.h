//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketsViewControllerDelegate.h"
#import "TicketCache.h"
#import "TicketDetailsViewController.h"

@interface TicketSelectionMgr : NSObject <TicketsViewControllerDelegate>
{
    TicketCache * ticketCache;
    UINavigationController * navController;
    TicketDetailsViewController * detailsViewController;
}

- (id)initWithTicketCache:
    (TicketCache *)aTicketCache
    navigationController:
    (UINavigationController *)aNavController
    ticketDetailsViewController:
    (TicketDetailsViewController *)aDetailsViewController;

@end
