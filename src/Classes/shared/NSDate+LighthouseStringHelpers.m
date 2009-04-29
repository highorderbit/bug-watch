//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSDate+LighthouseStringHelpers.h"
#import "NSDate+StringHelpers.h"

@implementation NSDate (LighthouseStringHelpers)

+ (NSDate *)dateWithLighthouseString:(NSString *)s
{
    // Example string: 2009-03-13T11:40:32-07:00
    static NSString * FORMAT_STRING = @"yyyy-MM-dd'T'HH:mm:SSZZZ";

    return [NSDate dateFromString:s format:FORMAT_STRING];
}

@end
