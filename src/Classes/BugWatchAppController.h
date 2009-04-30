//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketsViewController.h"
#import "TicketCache.h"
#import "TicketSelectionMgr.h"

@interface BugWatchAppController : NSObject
{
    IBOutlet TicketsViewController * ticketsViewController;
    IBOutlet UINavigationController * ticketsNavController;

    TicketCache * ticketCache;
}

- (void)start;

@end
