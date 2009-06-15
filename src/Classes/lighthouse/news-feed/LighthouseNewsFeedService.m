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

- (id)initWithUrlBuilder:(LighthouseUrlBuilder *)urlBuilder
             credentials:(LighthouseCredentials *)credentials
{
    if (self = [super init]) {
        newsFeed = [[LighthouseNewsFeed alloc] initWithUrlBuilder:urlBuilder
                                                      credentials:credentials];
        newsFeed.delegate = self;

        parser = [[LighthouseNewsFeedParser alloc] init];
    }

    return self;
}

- (void)setCredentials:(LighthouseCredentials *)credentials
{
    newsFeed.credentials = credentials;
}

#pragma mark Refreshing the news feed

- (void)fetchNewsFeed
{
    [newsFeed fetchNewsFeed];
}

#pragma mark LightHouseNewsFeedDelegate implementation

- (void)fetchedNewsFeed:(NSData *)rawFeed
{
    NSArray * parsedFeed = [parser parse:rawFeed];
    [delegate fetchedNewsFeed:parsedFeed];
}

- (void)failedToFetchNewsFeed:(NSError *)error
{
    [delegate failedToFetchNewsFeed:error];
}

@end
