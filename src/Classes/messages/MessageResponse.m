//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageResponse.h"

@interface MessageResponse ()

@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) NSDate * date;

@end

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
        self.text = someText;
        self.date = aDate;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"message response: '%@', '%@'",
        self.date, self.text];
}

@end
