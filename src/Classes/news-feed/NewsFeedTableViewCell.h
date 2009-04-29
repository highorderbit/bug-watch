//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewCell : UITableViewCell
{
    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * pubDateLabel;
    IBOutlet UILabel * bodyLabel;
    IBOutlet UILabel * entityTypeLabel;
}

- (void)updateView:(NSDictionary *)attrs;

@end
