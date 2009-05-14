//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketBinDataSource.h"

@implementation TicketBinDataSource

@synthesize delegate;

- (void)dealloc
{
    [service release];
    [super dealloc];
}

-(id)initWithService:(LighthouseApiService *)aService
{
    if (self = [super init])
        service = [aService retain];

    return self;
}

- (void)fetchAllTicketBins
{
    // TEMPORARY
    static NSString * token = @"6998f7ed27ced7a323b256d83bd7fec98167b1b3";
    [service fetchTicketBins:token];
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)fetchedTicketBins:(NSArray *)ticketBins token:(NSString *)token
{
    NSLog(@"Received ticket bins: ", ticketBins);
    [delegate receivedTicketBinsFromDataSource:ticketBins];
}

@end
