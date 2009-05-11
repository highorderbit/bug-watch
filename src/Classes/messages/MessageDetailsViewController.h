//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailsViewController : UITableViewController
{
    IBOutlet UIView * headerView;
    IBOutlet UIView * metaDataView;
    IBOutlet UIImageView * gradientImage;

    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * dateLabel;
    IBOutlet UILabel * projectLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * commentLabel;
}

- (void)setAuthorName:(NSString *)authorName date:(NSDate *)date
    projectName:(NSString *)projectName title:(NSString *)title
    comment:(NSString *)comment;

@end
