//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "Message.h"

@interface Message ()

@property (nonatomic, copy) NSDate * postedDate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * link;

@end

@implementation Message

@synthesize postedDate;
@synthesize title;
@synthesize message;
@synthesize link;

- (void)dealloc
{
    self.postedDate = nil;
    self.title = nil;
    self.message = nil;
    self.link = nil;
    [super dealloc];
}

- (id)initWithPostedDate:(NSDate *)aPostedDate title:(NSString *)aTitle
    message:(NSString *)aMessage link:(NSString *)aLink
{
    if (self = [super init]) {
        self.postedDate = aPostedDate;
        self.title = aTitle;
        self.message = aMessage;
        self.link = aLink;
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
        "message: '%@', link: '%@'.", self.title, self.postedDate, self.message,
        self.link];
}

- (NSComparisonResult)compare:(Message *)anotherMessage
{
    return [anotherMessage.postedDate compare:self.postedDate];
}

@end
