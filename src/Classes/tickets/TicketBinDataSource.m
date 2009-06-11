//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketBinDataSource.h"

@implementation TicketBinDataSource

@synthesize delegate;

- (void)dealloc
{
    [service release];
    [token release];
    [super dealloc];
}

- (id)initWithService:(LighthouseApiService *)aService token:(NSString *)aToken
{
    if (self = [super init]) {
        service = [aService retain];
        token = [aToken retain];
    }

    return self;
}

- (void)fetchAllTicketBinsForProject:(id)projectKey
{
    [service fetchTicketBinsForProject:projectKey token:token];
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)fetchedTicketBins:(NSArray *)ticketBins forProject:(id)projectKey
{
    NSLog(@"Received ticket bins: %@", ticketBins);
    [delegate receivedTicketBinsFromDataSource:ticketBins];
}

@end
