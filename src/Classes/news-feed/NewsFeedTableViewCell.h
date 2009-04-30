//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsFeedItem;

@interface NewsFeedTableViewCell : UITableViewCell
{
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * pubDateLabel;
    IBOutlet UILabel * bodyLabel;
    IBOutlet UILabel * entityTypeLabel;

    NewsFeedItem * newsFeedItem;
}

@property (nonatomic, copy) NewsFeedItem * newsFeedItem;

+ (CGFloat)heightForContent:(NewsFeedItem *)item;

@end
