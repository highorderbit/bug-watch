//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewsFeedDataSourceDelegate

- (void)newsFeedUpdated:(NSArray *)newsFeed;
- (void)failedToUpdateNewsFeed:(NSError *)error;

@end
