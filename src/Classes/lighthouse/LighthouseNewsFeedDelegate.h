//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseNewsFeedDelegate

- (void)newsFeed:(NSData *)newsFeed fetchedForToken:(NSString *)token;
- (void)failedToFetchNewsFeedForToken:(NSString *)token error:(NSError *)error;

@end
