//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketKey.h"

@implementation TicketKey

@synthesize projectKey, ticketNumber;

- (id)initWithProjectKey:(NSUInteger)aProjectKey
    ticketNumber:(NSUInteger)aTicketNumber
{
    if (self = [super init]) {
        projectKey = aProjectKey;
        ticketNumber = aTicketNumber;
    }

    return self;
}

- (id)copy
{
    return [self retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (BOOL)isEqual:(id)anObject
{
    TicketKey * aTicketKey = (TicketKey *)anObject;
    NSUInteger aProjectKey = aTicketKey.projectKey;
    NSUInteger aTicketNumber = aTicketKey.ticketNumber;

    return projectKey == aProjectKey && ticketNumber == aTicketNumber;
}

- (NSUInteger)hash
{
    return [[self description] hash];
}

- (NSComparisonResult)compare:(TicketKey *)anotherTicketKey
{
    NSNumber * number = [NSNumber numberWithInt:self.ticketNumber];
    NSNumber * anotherNumber =
        [NSNumber numberWithInt:anotherTicketKey.ticketNumber];

    return [number compare:anotherNumber];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{%d, %d}", projectKey,
        ticketNumber];
}

@end
