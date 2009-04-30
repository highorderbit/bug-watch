//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketSelectionMgr.h"

@implementation TicketSelectionMgr

- (void)dealloc
{
    [ticketCache release];
    [navController release];
    [detailsViewController release];
    [super dealloc];
}

- (id)initWithTicketCache:
    (TicketCache *)aTicketCache
    navigationController:
    (UINavigationController *)aNavController
    ticketDetailsViewController:
    (TicketDetailsViewController *)aDetailsViewController
{
    if (self = [super init]) {
        ticketCache = [aTicketCache retain];
        navController = [aNavController retain];
        detailsViewController = [aDetailsViewController retain];
    }

    return self;
}

- (void)selectedTicketNumber:(NSUInteger)number
{
    NSLog(@"Ticket %d selected", number);
    [navController pushViewController:detailsViewController animated:YES];
}

@end
