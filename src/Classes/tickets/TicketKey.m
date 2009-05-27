//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketKey.h"

@implementation TicketKey

@synthesize projectKey, ticketNumber;

- (void)dealloc
{
    [projectKey release];
    [super dealloc];
}

- (id)initWithProjectKey:(id)aProjectKey ticketNumber:(NSUInteger)aTicketNumber
{
    if (self = [super init]) {
        projectKey = [aProjectKey retain];
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
    id aProjectKey = aTicketKey.projectKey;
    NSUInteger aTicketNumber = aTicketKey.ticketNumber;

    return (projectKey == projectKey || [projectKey isEqual:aProjectKey])
        && ticketNumber == aTicketNumber;
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
    return [NSString stringWithFormat:@"ticket key: %@, %d", projectKey,
        ticketNumber];
}

@end
