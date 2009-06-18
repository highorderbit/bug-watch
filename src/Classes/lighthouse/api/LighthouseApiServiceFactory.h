//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"

@class CredentialsUpdatePublisher, LighthouseCredentials;

@interface LighthouseApiServiceFactory : NSObject
{
    NSString * lighthouseDomain;
    NSString * lighthouseScheme;

    CredentialsUpdatePublisher * credentialsUpdatePublisher;
    LighthouseCredentials * credentials;
}

- (id)initWithLighthouseDomain:(NSString *)domain scheme:(NSString *)scheme;

- (LighthouseApiService *)createLighthouseApiService;

@end
