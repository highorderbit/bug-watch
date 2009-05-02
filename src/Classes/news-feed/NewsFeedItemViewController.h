//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsFeedItem;
@class RoundedRectLabel;

@interface NewsFeedItemViewController : UIViewController
{
    IBOutlet UIView * headerView;
    IBOutlet UIView * dropShadowView;
    IBOutlet UIWebView * bodyView;

    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet RoundedRectLabel * entityTypeLabel;
    IBOutlet UILabel * timestampLabel;
    IBOutlet UIImageView  * headerGradientView;

    NewsFeedItem * newsFeedItem;
}

@property (nonatomic, copy, readonly) NewsFeedItem * newsFeedItem;

- (void)updateNewsItem:(NewsFeedItem *)item;

@end
