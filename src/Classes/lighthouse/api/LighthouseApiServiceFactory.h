//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"

@interface LighthouseApiServiceFactory : NSObject
{
    NSString * lighthouseDomain;
    NSString * lighthouseScheme;
}

- (id)initWithLighthouseDomain:(NSString *)domain scheme:(NSString *)scheme;

- (LighthouseApiService *)createLighthouseApiService;

@end
