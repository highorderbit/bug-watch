//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LighthouseUrlBuilder : NSObject <NSCopying>
{
    NSString * lighthouseDomain;
    NSString * lighthouseScheme;
}

@property (nonatomic, copy, readonly) NSString * lighthouseDomain;
@property (nonatomic, copy, readonly) NSString * lighthouseScheme;

+ (id)builderWithLighthouseDomain:(NSString *)domain scheme:(NSString *)scheme;
- (id)initWithLighthouseDomain:(NSString *)domain scheme:(NSString *)scheme;

- (NSURL *)urlForPath:(NSString *)path;
- (NSURL *)urlForPath:(NSString *)path
                 args:(id)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

@end
