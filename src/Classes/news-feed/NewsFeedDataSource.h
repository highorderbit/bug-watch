//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedDataSourceDelegate.h"
#import "LighthouseNewsFeedServiceDelegate.h"

@class LighthouseNewsFeedService;

@interface NewsFeedDataSource : NSObject <LighthouseNewsFeedServiceDelegate>
{
    id<NewsFeedDataSourceDelegate> delegate;

    LighthouseNewsFeedService * service;

    NSArray * cache;
    BOOL needsUpdating;
}

@property (nonatomic, assign) id<NewsFeedDataSourceDelegate> delegate;
@property (nonatomic, readonly) NSArray * cache;

#pragma mark Initialization

- (id)initWithNewsFeedService:(LighthouseNewsFeedService *)aService
    cache:(NSArray *)aCache;

#pragma mark Fetching current data

- (NSArray *)currentNewsFeed;

#pragma mark Updating the contained data

- (BOOL)fetchNewsFeedIfNecessary;
- (void)refreshNewsFeed;

@end
