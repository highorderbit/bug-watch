//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSDateLighthouseApiTypeConverter.h"
#import "NSDate+LighthouseStringHelpers.h"

@implementation NSDateLighthouseApiTypeConverter

+ (id)converter
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)convert:(NSString *)value
{
    return [NSDate dateWithLighthouseString:value];
}

@end
