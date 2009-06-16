//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseNewsFeedDelegate.h"
#import "LighthouseNewsFeedServiceDelegate.h"

#import "LighthouseUrlBuilder.h"
#import "LighthouseCredentials.h"

@class LighthouseNewsFeed, LighthouseNewsFeedParser;

@interface LighthouseNewsFeedService : NSObject <LighthouseNewsFeedDelegate>
{
    id<LighthouseNewsFeedServiceDelegate> delegate;

    LighthouseNewsFeed * newsFeed;
    LighthouseNewsFeedParser * parser;
}

@property (nonatomic, assign) id<LighthouseNewsFeedServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithUrlBuilder:(LighthouseUrlBuilder *)urlBuilder
             credentials:(LighthouseCredentials *)credentials;

#pragma mark Changing user credentials

- (LighthouseCredentials *)credentials;
- (void)setCredentials:(LighthouseCredentials *)credentials;

#pragma mark Refreshing the news feed

- (void)fetchNewsFeed;

@end
