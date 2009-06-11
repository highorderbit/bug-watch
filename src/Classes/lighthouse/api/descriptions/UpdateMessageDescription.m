//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UpdateMessageDescription.h"

@implementation UpdateMessageDescription

@synthesize title, body;

+ (id)description
{
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc
{
    self.title = nil;
    self.body = nil;
    [super dealloc];
}

- (id)init
{
    return (self = [super init]);
}

- (id)copyWithZone:(NSZone *)zone
{
    UpdateMessageDescription * desc = [[[self class] allocWithZone:zone] init];
    desc.title = self.title;
    desc.body = self.body;

    return desc;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"title: '%@', body: '%@'", title, body];
}

- (NSString *)xmlDescription
{
    NSMutableString * xml = [NSMutableString string];
    [xml appendString:@"<message>\n"];

    if (self.title)
        [xml appendFormat:@"\t<title>%@</title>", self.title];

    if (self.body)
        [xml appendFormat:@"\t<body>%@</body>\n", self.body];

    [xml appendString:@"</message>"];

    return xml;
}

@end
