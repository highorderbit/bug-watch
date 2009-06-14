//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "LighthouseKey.h"

@implementation LighthouseKey

@synthesize projectKey, key;

- (id)initWithProjectKey:(NSUInteger)aProjectKey key:(NSUInteger)aKey
{
    if (self = [super init]) {
        projectKey = aProjectKey;
        key = aKey;
    }

    return self;
}

- (id)copy
{
    return [self retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (BOOL)isEqual:(id)anObject
{
    LighthouseKey * aLighthouseKey = (LighthouseKey *)anObject;
    NSUInteger aProjectKey = aLighthouseKey.projectKey;
    NSUInteger aKey = aLighthouseKey.key;

    return projectKey == aProjectKey && key == aKey;
}

- (NSUInteger)hash
{
    return [[self description] hash];
}

- (NSComparisonResult)compare:(LighthouseKey *)anotherLighthouseKey
{
    NSNumber * number = [NSNumber numberWithInt:self.key];
    NSNumber * anotherNumber =
        [NSNumber numberWithInt:anotherLighthouseKey.key];

    return [number compare:anotherNumber];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{%d, %d}", projectKey, key];
}

@end
