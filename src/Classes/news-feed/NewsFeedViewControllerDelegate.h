//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsFeedItem;

@protocol NewsFeedViewControllerDelegate

- (void)userDidSelectNewsItem:(NewsFeedItem *)item;

@end
