//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedDataSource.h"
#import "LighthouseNewsFeedService.h"
#import "NewsFeedItem.h"  // delete when not returning dummy data

@interface NewsFeedDataSource (Private)

- (void)setCache:(NSArray *)aCache;

@end

@implementation NewsFeedDataSource

@synthesize delegate;

- (void)dealloc
{
    [service release];
    [cache release];
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithNewsFeedService:(LighthouseNewsFeedService *)aService
{
    if (self = [super init]) {
        service = [aService retain];
        service.delegate = self;

        cache = [[NewsFeedItem dummyData] retain];
        needsUpdating = YES;
    }

    return self;
}

#pragma mark Fetching current data

- (NSArray *)currentNewsFeed
{
    return cache;
}

#pragma mark Updating the contained data

- (BOOL)fetchNewsFeedIfNecessary
{
    if (needsUpdating)
        [service fetchNewsFeed:@"6998f7ed27ced7a323b256d83bd7fec98167b1b3"];

    return needsUpdating;
}

- (void)refreshNewsFeed
{
    needsUpdating = YES;
    [self fetchNewsFeedIfNecessary];
}

#pragma mark LighthouseNewsFeedServiceDelegate implementation

- (void)newsFeed:(NSArray *)newsFeed fetchedForToken:(NSString *)token
{
    needsUpdating = NO;
    [self setCache:newsFeed];
    [delegate newsFeedUpdated:newsFeed];
}

#pragma mark Accessors

- (void)setCache:(NSArray *)aCache
{
    NSArray * tmp = [aCache copy];
    [cache release];
    cache = tmp;
}

@end
