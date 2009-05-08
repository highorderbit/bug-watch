//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "TicketNumber.h"

@implementation TicketNumber

@synthesize ticketNumber;

- (void)dealloc
{
    [ticketNumber release];
    [super dealloc];
}

@end
