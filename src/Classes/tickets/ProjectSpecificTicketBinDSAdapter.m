//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectSpecificTicketBinDSAdapter.h"

@implementation ProjectSpecificTicketBinDSAdapter

@synthesize delegate, ticketDisplayMgr;

- (void)dealloc
{
    [ticketDisplayMgr release];
    [ticketBinDataSource release];
    [super dealloc];
}

- (id)initWithTicketBinDataSource:(TicketBinDataSource *)aTicketBinDataSource
{
    if (self = [super init])
        ticketBinDataSource = [aTicketBinDataSource retain];

    return self;
}

- (void)fetchAllTicketBins
{
    [ticketBinDataSource
        fetchAllTicketBinsForProject:ticketDisplayMgr.activeProjectKey];
}

- (void)receivedTicketBinsFromDataSource:(NSArray *)someTicketBins
{
    [delegate receivedTicketBinsFromDataSource:someTicketBins];
}

- (void)failedToFetchTicketBins:(NSArray *)errors
{
    [delegate failedToFetchTicketBins:errors];
}

@end
