//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseNewsFeedServiceDelegate

- (void)fetchedNewsFeed:(NSArray *)newsFeed;
- (void)failedToFetchNewsFeed:(NSError *)error;

@end
