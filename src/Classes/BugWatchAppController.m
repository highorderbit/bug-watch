//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"

@implementation BugWatchAppController

- (void)dealloc
{
    [ticketsViewController release];
    [ticketsNavController release];
    [ticketDetailsViewController release];

    [ticketCache release];

    [super dealloc];
}

- (void)start
{
    ticketCache = [[TicketCache alloc] init];
    TicketSelectionMgr * ticketSelectionMgr =
        [[TicketSelectionMgr alloc] initWithTicketCache:ticketCache
        navigationController:ticketsNavController
        ticketDetailsViewController:ticketDetailsViewController];
    ticketsViewController.delegate = ticketSelectionMgr;
}

@end
