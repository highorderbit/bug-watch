//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "LighthouseApiServiceFactory.h"

@implementation LighthouseApiServiceFactory

- (void)dealloc
{
    [baseUrl release];
    [super dealloc];
}

- (id)initWithBaseUrl:(NSString *)aBaseUrl
{
    if (self = [super init])
        baseUrl = [aBaseUrl copy];

    return self;
}

- (LighthouseApiService *)createLighthouseApiService
{
    return [[[LighthouseApiService alloc]
        initWithBaseUrlString:baseUrl] autorelease];
}

@end
