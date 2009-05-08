//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceApiDelegate.h"
#import "LighthouseNewsFeedDelegate.h"

@class WebServiceApi, WebServiceResponseDispatcher;

@interface LighthouseNewsFeed : NSObject <WebServiceApiDelegate>
{
    id<LighthouseNewsFeedDelegate> delegate;

    NSString * baseUrlString;

    WebServiceApi * api;
    WebServiceResponseDispatcher * dispatcher;
}

@property (nonatomic, assign) id<LighthouseNewsFeedDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString;

#pragma mark Fetching news feeds

- (void)fetchNewsFeed:(NSString *)token;

@end
