//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSString+UrlEncodingAdditions.h"

@implementation NSString (UrlEncodingAdditions)

- (NSString *)urlEncodedString
{
    return [self
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)urlEncodedStringWithEscapedAllowedCharacters:(NSString *)allowed
{
    id escapedString = (id)
        CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            (CFStringRef) self,
            (CFStringRef) NULL,
            (CFStringRef) allowed,
            kCFStringEncodingUTF8);

    return [escapedString autorelease];
}

@end
