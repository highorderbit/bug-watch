//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

@synthesize description;
@synthesize message;
@synthesize creationDate;
@synthesize link;

- (void)dealloc
{
    [description release];
    [message release];
    [creationDate release];
    [link release];
    [super dealloc];
}

- (id)initWithDescription:(NSString *)aDescription message:(NSString*)aMessage
    creationDate:(NSDate *)aCreationDate link:(NSString *)aLink
{
    if (self = [super init]) {
        description = [aDescription copy];
        message = [aMessage copy];
        creationDate = [aCreationDate copy];
        link = [aLink copy];
    }

    return self;
}

- (id)copy
{
    return [self retain]; // safe because immutable
}

- (NSComparisonResult)compare:(Ticket *)anotherTicket
{
    return [self.creationDate compare:anotherTicket.creationDate];
}

@end
