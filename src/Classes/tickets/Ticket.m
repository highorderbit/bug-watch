//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

@synthesize description;
@synthesize message;
@synthesize creationDate;

- (void)dealloc
{
    [description release];
    [message release];
    [creationDate release];
    [super dealloc];
}

- (id)initWithDescription:(NSString *)aDescription message:(NSString*)aMessage
    creationDate:(NSDate *)aCreationDate
{
    if (self = [super init]) {
        description = [aDescription retain];
        message = [aMessage retain];
        creationDate = [aCreationDate retain];
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
