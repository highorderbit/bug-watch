//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketCache.h"

@implementation TicketCache

- (void)dealloc
{
    [tickets release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
        tickets = [[NSMutableDictionary dictionary] retain];
    
    return self;
}

- (void)setTicket:(Ticket *)ticket forNumber:(NSUInteger)number
{
    [tickets setObject:ticket forKey:[NSNumber numberWithInt:number]];
}

- (Ticket *)ticketForNumber:(NSUInteger)number
{
    return [[tickets objectForKey:[NSNumber numberWithInt:number]] copy];
}

@end
