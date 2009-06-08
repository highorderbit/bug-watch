//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"

@interface LighthouseApiServiceFactory : NSObject
{
    NSString * baseUrl;
}

- (id)initWithBaseUrl:(NSString *)baseUrl;

- (LighthouseApiService *)createLighthouseApiService;

@end
