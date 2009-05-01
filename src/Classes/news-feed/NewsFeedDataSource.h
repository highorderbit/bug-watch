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

    NSArray * cache;  // Temporary
    BOOL needsUpdating;
}

@property (nonatomic, assign) id<NewsFeedDataSourceDelegate> delegate;

#pragma mark Initialization

- (id)initWithNewsFeedService:(LighthouseNewsFeedService *)aService;

#pragma mark Fetching current data

- (NSArray *)currentNewsFeed;

#pragma mark Updating the contained data

- (BOOL)fetchNewsFeedIfNecessary;
- (void)refreshNewsFeed;

@end
