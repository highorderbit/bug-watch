//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+InstantiationAdditions.h"

@class Milestone;
@class RoundedRectView;

@interface MilestonesTableViewCell : UITableViewCell
{
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * dueDateLabel;

    IBOutlet RoundedRectView * numOpenTicketsView;
    IBOutlet UILabel * numOpenTicketsLabel;
    IBOutlet UILabel * numOpenTicketsTitleLabel;
    UIColor * numOpenTicketsViewBackgroundColor;

    IBOutlet UIProgressView * progressView;

    Milestone * milestone;
}

@property (nonatomic, copy) Milestone * milestone;

@end
