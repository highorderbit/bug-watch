//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseNewsFeedServiceDelegate

- (void)newsFeed:(NSArray *)newsFeed fetchedForToken:(NSString *)token;

@end
