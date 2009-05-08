//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize postedDate;
@synthesize title;
@synthesize message;

- (void)dealloc
{
    [postedDate release];
    [title release];
    [message release];
    [super dealloc];
}

- (id)initWithPostedDate:(NSDate *)aPostedDate title:(NSString *)aTitle
    message:(NSString *)aMessage
{
    if (self = [super init]) {
        postedDate = [aPostedDate retain];
        title = [aTitle retain];
        message = [aMessage retain];
    }

    return self;
}

- (id)copy
{
    return self;
}

@end
