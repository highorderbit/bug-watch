//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketComment.h"

@implementation TicketComment

@synthesize stateChangeDescription;
@synthesize text;
@synthesize date;

- (id) initWithStateChangeDescription:(NSString *)aStateChangeDescription
    text:(NSString *)someText date:(NSDate *)aDate
{
    if (self = [super init]) {
        stateChangeDescription = [aStateChangeDescription retain];
        text = [someText retain];
        date = [aDate retain];
    }

    return self;
}

- (id)copy
{
    return [self retain]; // safe because immutable
}

@end
