//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedDataSource.h"
#import "LighthouseNewsFeedService.h"

@interface NewsFeedDataSource (Private)

- (void)setCache:(NSArray *)aCache;

@end

@implementation NewsFeedDataSource

@synthesize delegate;
@synthesize cache;

- (void)dealloc
{
    [service release];
    [cache release];
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithNewsFeedService:(LighthouseNewsFeedService *)aService
    cache:(NSArray *)aCache
{
    if (self = [super init]) {
        service = [aService retain];
        service.delegate = self;

        [self setCache:aCache];
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
        [service fetchNewsFeed];

    return needsUpdating;
}

- (void)refreshNewsFeed
{
    needsUpdating = YES;
    [self fetchNewsFeedIfNecessary];
}

#pragma mark LighthouseNewsFeedServiceDelegate implementation

- (void)fetchedNewsFeed:(NSArray *)newsFeed
{
    needsUpdating = NO;
    [self setCache:newsFeed];
    [delegate newsFeedUpdated:newsFeed];
}

- (void)failedToFetchNewsFeed:(NSError *)error
{
    [delegate failedToUpdateNewsFeed:error];
}

#pragma mark Accessors

- (void)setCache:(NSArray *)aCache
{
    NSArray * tmp = [aCache copy];
    [cache release];
    cache = tmp;
}

@end
