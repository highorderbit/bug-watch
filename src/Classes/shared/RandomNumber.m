//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RandomNumber.h"

@implementation RandomNumber

+ (void)initialize
{
    srand([[NSDate date] timeIntervalSince1970]);
}

+ (id)randomNumber
{
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc
{
    [number release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
        number = [[NSNumber alloc] initWithInteger:rand()];

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%d", [number integerValue]];
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

@end
