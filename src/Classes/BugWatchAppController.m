//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"
#import "TicketDetailsViewController.h"

@implementation BugWatchAppController

- (void)dealloc
{
    [ticketsViewController release];
    [ticketsNavController release];

    [ticketCache release];

    [super dealloc];
}

- (void)start
{
    ticketCache = [[TicketCache alloc] init];
    
    TicketDetailsViewController * ticketDetailsViewController =
        [[TicketDetailsViewController alloc]
        initWithNibName:@"TicketDetailsView" bundle:nil];
    TicketSelectionMgr * ticketSelectionMgr =
        [[TicketSelectionMgr alloc] initWithTicketCache:ticketCache
        navigationController:ticketsNavController
        ticketDetailsViewController:ticketDetailsViewController];
    ticketsViewController.delegate = ticketSelectionMgr;
}

@end
