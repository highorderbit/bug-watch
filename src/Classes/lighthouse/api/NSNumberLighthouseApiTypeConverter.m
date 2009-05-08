//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSNumberLighthouseApiTypeConverter.h"

@implementation NSNumberLighthouseApiTypeConverter

+ (id)converter
{
    return [[[[self class] alloc] init] autorelease];
}

- (id)convert:(NSString *)value
{
    return [NSNumber numberWithInteger:[value integerValue]];
}

@end
