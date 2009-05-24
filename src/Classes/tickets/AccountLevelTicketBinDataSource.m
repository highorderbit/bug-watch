//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "AccountLevelTicketBinDataSource.h"
#import "TicketBin.h"

@interface AccountLevelTicketBinDataSource (Private)

@property (nonatomic, readonly) NSArray * ticketBins;

@end

@implementation AccountLevelTicketBinDataSource

- (void)dealloc
{
    [ticketBins release];
    [super dealloc];
}

@synthesize delegate;

- (void)fetchAllTicketBins
{
    [delegate receivedTicketBinsFromDataSource:self.ticketBins];
}

- (NSArray *)ticketBins
{
    if (!ticketBins) {
        NSMutableArray * mutableTicketBins = [NSMutableArray array];

        TicketBin * allTicketBin =
            [TicketBin ticketBinWithName:@"All tickets" searchString:@"all"
            ticketCount:UNKNOWN_TICKET_BIN_COUNT];
        [mutableTicketBins addObject:allTicketBin];
        TicketBin * todaysTicketBin =
            [TicketBin ticketBinWithName:@"Today's tickets"
            searchString:@"created:today" ticketCount:UNKNOWN_TICKET_BIN_COUNT];
        [mutableTicketBins addObject:todaysTicketBin];
        TicketBin * watchingTicketBin =
            [TicketBin ticketBinWithName:@"Tickets I'm watching"
            searchString:@"watched:me" ticketCount:UNKNOWN_TICKET_BIN_COUNT];
        [mutableTicketBins addObject:watchingTicketBin];
        TicketBin * myTicketBin =
            [TicketBin ticketBinWithName:@"Assigned to me"
            searchString:@"responsible:me"
            ticketCount:UNKNOWN_TICKET_BIN_COUNT];
        [mutableTicketBins addObject:myTicketBin];
        TicketBin * reportedByMeTicketBin =
            [TicketBin ticketBinWithName:@"Reported by me"
            searchString:@"reported_by:me"
            ticketCount:UNKNOWN_TICKET_BIN_COUNT];
        [mutableTicketBins addObject:reportedByMeTicketBin];
        TicketBin * openTicketBin =
            [TicketBin ticketBinWithName:@"Open tickets"
            searchString:@"state:open" ticketCount:UNKNOWN_TICKET_BIN_COUNT];
        [mutableTicketBins addObject:openTicketBin];
        TicketBin * closedTicketBin =
            [TicketBin ticketBinWithName:@"Closed tickets"
            searchString:@"state:closed" ticketCount:UNKNOWN_TICKET_BIN_COUNT];
        [mutableTicketBins addObject:closedTicketBin];

        ticketBins = [mutableTicketBins retain];
    }

    return ticketBins;
}

@end
