//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

@interface TicketCache : NSObject
{
    NSMutableDictionary * tickets;
}

- (void)setTicket:(Ticket *)ticket forNumber:(NSUInteger)number;
- (Ticket *)ticketForNumber:(NSUInteger)number;

@end
