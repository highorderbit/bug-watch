//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "LighthouseApiServiceFactory.h"
#import "CredentialsUpdatePublisher.h"
#import "LighthouseCredentials.h"

@interface LighthouseApiServiceFactory ()

@property (nonatomic, copy) NSString * lighthouseDomain;
@property (nonatomic, copy) NSString * lighthouseScheme;

@property (nonatomic, retain) CredentialsUpdatePublisher *
    credentialsUpdatePublisher;
@property (nonatomic, retain) LighthouseCredentials * credentials;

@end

@implementation LighthouseApiServiceFactory

@synthesize lighthouseDomain, lighthouseScheme;
@synthesize credentialsUpdatePublisher, credentials;

- (void)dealloc
{
    self.lighthouseDomain = nil;
    self.lighthouseScheme = nil;
    self.credentialsUpdatePublisher = nil;
    self.credentials = nil;
    [super dealloc];
}

- (id)initWithLighthouseDomain:(NSString *)domain
                        scheme:(NSString *)scheme
                   credentials:(LighthouseCredentials *)someCredentials
{
    if (self = [super init]) {
        self.lighthouseDomain = domain;
        self.lighthouseScheme = scheme;

        self.credentials = someCredentials;
        credentialsUpdatePublisher = [[CredentialsUpdatePublisher alloc]
            initWithListener:self action:@selector(credentialsChanged:)];
    }

    return self;
}

- (LighthouseApiService *)createLighthouseApiService
{
    LighthouseUrlBuilder * urlBuilder =
        [LighthouseUrlBuilder builderWithLighthouseDomain:lighthouseDomain
                                                   scheme:lighthouseScheme];

    LighthouseApiService * service =
        [[LighthouseApiService alloc] initWithUrlBuilder:urlBuilder
                                             credentials:credentials];

    return [service autorelease];
}

#pragma mark Notification when credentials change

- (void)credentialsChanged:(LighthouseCredentials *)someCredentials
{
    self.credentials = someCredentials;
}

@end
