//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketSelectionMgr.h"

@implementation TicketSelectionMgr

- (void)dealloc
{
    [ticketCache release];
    [navController release];
    [ticketsViewController release];
    [detailsViewController release];
    [super dealloc];
}

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    navigationController:(UINavigationController *)aNavController
    ticketsViewController:(TicketsViewController *)aTicketsViewController;
{
    if (self = [super init]) {
        ticketCache = [aTicketCache retain];
        navController = [aNavController retain];
        ticketsViewController = [aTicketsViewController retain];
    }

    return self;
}


#pragma mark TicketsViewControllerDelegate implementation

- (void)selectedTicketNumber:(NSUInteger)number
{
    NSLog(@"Ticket %d selected", number);
    
    Ticket * ticket = [ticketCache ticketForNumber:number];
    [self.detailsViewController setTicketNumber:number ticket:ticket];

    [navController pushViewController:self.detailsViewController animated:YES];
}

- (void)ticketsFilteredByFilterKey:(NSString *)filterKey
{
    [ticketsViewController setTickets:[ticketCache allTickets]];
}

#pragma mark Accessors

- (TicketDetailsViewController *)detailsViewController
{
    if (!detailsViewController) {
        TicketDetailsViewController * ticketDetailsViewController =
            [[TicketDetailsViewController alloc]
            initWithNibName:@"TicketDetailsView" bundle:nil];
            
        detailsViewController = ticketDetailsViewController;
    }
        
    return detailsViewController;
}

@end
