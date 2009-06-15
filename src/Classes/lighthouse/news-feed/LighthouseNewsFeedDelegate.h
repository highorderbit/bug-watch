//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseNewsFeedDelegate

- (void)fetchedNewsFeed:(NSData *)newsFeed;
- (void)failedToFetchNewsFeed:(NSError *)error;

@end
