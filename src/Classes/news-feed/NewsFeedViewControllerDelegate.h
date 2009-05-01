//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewsFeedItem;

@protocol NewsFeedViewControllerDelegate

- (void)viewDidLoad;
- (void)viewWillAppear;

- (void)userDidSelectNewsItem:(NewsFeedItem *)item;
- (void)userDidRequestRefresh;

@end
