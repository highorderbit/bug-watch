//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsFeedItem;

@interface NewsFeedItemViewController : UIViewController
{
    IBOutlet UIView * headerView;
    IBOutlet UIView * dropShadowView;
    IBOutlet UIWebView * bodyView;

    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * entityTypeLabel;
    IBOutlet UILabel * timestampLabel;

    NewsFeedItem * newsFeedItem;
}

@property (nonatomic, copy, readonly) NewsFeedItem * newsFeedItem;

- (void)updateNewsItem:(NewsFeedItem *)item;

@end
