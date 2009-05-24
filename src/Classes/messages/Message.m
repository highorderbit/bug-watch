//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "Message.h"

@interface Message ()

@property (nonatomic, copy) NSDate * postedDate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;

@end

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
        self.postedDate = aPostedDate;
        self.title = aTitle;
        self.message = aMessage;
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Message '%@', posted date: '%@', "
        "message: '%@'", self.title, self.postedDate, self.message];
}

@end
