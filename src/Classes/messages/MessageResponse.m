//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageResponse.h"

@implementation MessageResponse

@synthesize text;
@synthesize date;

- (void)dealloc
{
    [text release];
    [date release];
    [super dealloc];
}

- (id)initWithText:(NSString *)someText date:(NSDate *)aDate
{
    if (self = [super init]) {
        text = [someText retain];
        date = [aDate retain];
    }
    
    return self;
}

- (id)copy
{
    return self;
}

@end
