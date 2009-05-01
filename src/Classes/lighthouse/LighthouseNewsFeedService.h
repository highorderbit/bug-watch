//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LightHouseNewsFeedDelegate.h"
#import "LightHouseNewsFeedServiceDelegate.h"

@class LighthouseNewsFeed, LighthouseNewsFeedParser;

@interface LighthouseNewsFeedService : NSObject <LighthouseNewsFeedDelegate>
{
    id<LighthouseNewsFeedServiceDelegate> delegate;

    LighthouseNewsFeed * newsFeed;
    LighthouseNewsFeedParser * parser;
}

@property (nonatomic, assign) id<LighthouseNewsFeedServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)baseUrlString;

#pragma mark Refreshing the news feed

- (void)fetchNewsFeed:(NSString *)token;

@end
