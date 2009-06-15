//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceApiDelegate.h"
#import "LighthouseNewsFeedDelegate.h"
#import "LighthouseUrlBuilder.h"
#import "LighthouseCredentials.h"

@class WebServiceApi, WebServiceResponseDispatcher;

@interface LighthouseNewsFeed : NSObject <WebServiceApiDelegate>
{
    id<LighthouseNewsFeedDelegate> delegate;

    LighthouseUrlBuilder * urlBuilder;
    LighthouseCredentials * credentials;

    WebServiceApi * api;
    WebServiceResponseDispatcher * dispatcher;
}

@property (nonatomic, assign) id<LighthouseNewsFeedDelegate> delegate;
@property (nonatomic, copy) LighthouseCredentials * credentials;

#pragma mark Initialization

- (id)initWithUrlBuilder:(LighthouseUrlBuilder *)aUrlBuilder
             credentials:(LighthouseCredentials *)someCredentials;

#pragma mark Fetching news feeds

- (void)fetchNewsFeed;

@end
