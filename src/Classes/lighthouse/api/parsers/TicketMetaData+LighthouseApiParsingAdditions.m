//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "TicketMetaData+LighthouseApiParsingAdditions.h"

@implementation TicketMetaData (LighthouseApiParsingAdditions)

+ (NSUInteger)stateForStateString:(NSString *)s
{
    if ([s isEqualToString:@"new"])
        return kNew;
    if ([s isEqualToString:@"open"])
        return kOpen;
    if ([s isEqualToString:@"resolved"])
        return kResolved;
    if ([s isEqualToString:@"hold"])
        return kHold;
    if ([s isEqualToString:@"invalid"])
        return kInvalid;

    return -1;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"state"] &&
        [value isKindOfClass:[NSString class]]) {
        NSUInteger stateVal = [[self class] stateForStateString:value];
        [super setValue:[NSNumber numberWithInteger:stateVal] forKey:key];
    } else
        [super setValue:value forKey:key];
}

@end

@implementation TicketDataWrapper (LighthouseApiParsingAdditions)

+ (NSUInteger)stateForStateString:(NSString *)s
{
    if ([s isEqualToString:@"new"])
        return kNew;
    if ([s isEqualToString:@"open"])
        return kOpen;
    if ([s isEqualToString:@"resolved"])
        return kResolved;
    if ([s isEqualToString:@"hold"])
        return kHold;
    if ([s isEqualToString:@"invalid"])
        return kInvalid;

    return -1;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"state"] &&
        [value isKindOfClass:[NSString class]]) {
        NSUInteger stateVal = [[self class] stateForStateString:value];
        [super setValue:[NSNumber numberWithInteger:stateVal] forKey:key];
    } else
        [super setValue:value forKey:key];
}

@end
