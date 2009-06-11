//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiTypeConverter.h"

@implementation LighthouseApiTypeConverter

+ (id)converter
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)convert:(NSString *)value
{
    NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [value stringByTrimmingCharactersInSet:set];
}

@end
