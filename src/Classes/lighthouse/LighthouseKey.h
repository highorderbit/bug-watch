//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LighthouseKey : NSObject <NSCopying>
{
    NSUInteger projectKey;
    NSUInteger key;
}

@property (nonatomic, readonly) NSUInteger projectKey;
@property (nonatomic, readonly) NSUInteger key;

- (id)initWithProjectKey:(NSUInteger)projectKey key:(NSUInteger)key;

- (NSComparisonResult)compare:(LighthouseKey *)anotherKey;

@end
