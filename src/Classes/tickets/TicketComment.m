//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketComment.h"

@implementation TicketComment

@synthesize stateChangeDescription, stateChange, text, date;

- (id) initWithStateChangeDescription:(NSString *)aStateChangeDescription
    stateChange:(TicketDiff *)aStateChange text:(NSString *)someText
    date:(NSDate *)aDate
{
    if (self = [super init]) {
        stateChangeDescription = [aStateChangeDescription copy];
        stateChange = [aStateChange copy];
        text = [someText copy];
        date = [aDate copy];
    }

    return self;
}

- (id)copy
{
    return [self retain]; // safe because immutable
}

- (NSString *)description
{
    return [NSString
        stringWithFormat:@"{stateChangeDescription:%@,text:%@,date:%@}",
        stateChangeDescription, text, [date description]];
}

- (NSComparisonResult)compare:(TicketComment *)anotherTicketComment
{
    return [self.date compare:anotherTicketComment.date];
}

@end
