//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseNewsFeedService.h"
#import "LighthouseNewsFeed.h"
#import "LighthouseNewsFeedParser.h"

@implementation LighthouseNewsFeedService

@synthesize delegate;

- (void)dealloc
{
    [newsFeed release];
    [parser release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)baseUrlString
{
    if (self = [super init]) {
        newsFeed =
            [[LighthouseNewsFeed alloc] initWithBaseUrlString:baseUrlString];
        newsFeed.delegate = self;

        parser = [[LighthouseNewsFeedParser alloc] init];
    }

    return self;
}

#pragma mark Refreshing the news feed

- (void)fetchNewsFeed:(NSString *)token
{
    [newsFeed fetchNewsFeed:token];
}

#pragma mark LightHouseNewsFeedDelegate implementation

- (void)newsFeed:(NSData *)rawFeed fetchedForToken:(NSString *)token
{
    NSArray * parsedFeed = [parser parse:rawFeed];
    [delegate newsFeed:parsedFeed fetchedForToken:token];
}

- (void)failedToFetchNewsFeedForToken:(NSString *)token error:(NSError *)error
{
}

@end
