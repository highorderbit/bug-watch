//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "LighthouseApiServiceFactory.h"

@interface LighthouseApiServiceFactory ()

@property (nonatomic, copy) NSString * lighthouseDomain;
@property (nonatomic, copy) NSString * lighthouseScheme;

@end

@implementation LighthouseApiServiceFactory

@synthesize lighthouseDomain, lighthouseScheme;

- (void)dealloc
{
    self.lighthouseDomain = nil;
    self.lighthouseScheme = nil;
    [super dealloc];
}

- (id)initWithLighthouseDomain:(NSString *)domain scheme:(NSString *)scheme
{
    if (self = [super init]) {
        self.lighthouseDomain = domain;
        self.lighthouseScheme = scheme;
    }

    return self;
}

- (LighthouseApiService *)createLighthouseApiService
{
    LighthouseUrlBuilder * urlBuilder =
        [LighthouseUrlBuilder builderWithLighthouseDomain:lighthouseDomain
                                                   scheme:lighthouseScheme];

    // temporary
    static NSString * account = @"highorderbit";
    static NSString * token = @"6998f7ed27ced7a323b256d83bd7fec98167b1b3";
    LighthouseCredentials * credentials =
            [[LighthouseCredentials alloc] initWithAccount:account token:token];

    LighthouseApiService * service =
        [[LighthouseApiService alloc] initWithUrlBuilder:urlBuilder
                                             credentials:credentials];

    [credentials release];

    return [service autorelease];
}

@end
