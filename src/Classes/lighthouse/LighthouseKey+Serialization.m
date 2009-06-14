//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "LighthouseKey+Serialization.h"

@interface LighthouseKey (Private)

+ (NSString *)splitSequence;

@end

@implementation LighthouseKey (Serialization)

+ (NSString *)stringFromLighthouseKey:(LighthouseKey *)ticketKey
{   
    return ticketKey ?
        [NSString stringWithFormat:@"%d%@%d",
        ticketKey.projectKey,
        [[self class] splitSequence], 
        ticketKey.key] :
        nil;
}

+ (LighthouseKey *)lighthouseKeyFromString:(NSString *)string
{
    LighthouseKey * ticketKey;
    if (string) {
        NSArray * components =
            [string componentsSeparatedByString:[[self class] splitSequence]];

        NSUInteger projectKey = [[components objectAtIndex:0] integerValue];
        NSUInteger ticketNumber = [[components objectAtIndex:1] integerValue];

        ticketKey =
            [[[LighthouseKey alloc]
            initWithProjectKey:projectKey key:ticketNumber]
            autorelease];
    } else
        ticketKey = nil;
    
    return ticketKey;
}

+ (NSString *)splitSequence
{
    return @"|";
}

@end
