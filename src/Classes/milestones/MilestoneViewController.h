//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Milestone;
@class RoundedRectView;
@class MilestoneProgressView;

@interface MilestoneViewController : UITableViewController
{
    IBOutlet UIView * headerView;

    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * dueDateLabel;

    IBOutlet RoundedRectView * numOpenTicketsView;
    IBOutlet UILabel * numOpenTicketsLabel;
    IBOutlet UILabel * numOpenTicketsTitleLabel;
    UIColor * numOpenTicketsViewBackgroundColor;

    IBOutlet MilestoneProgressView * progressView;

    Milestone * milestone;
}

@property (nonatomic, copy) Milestone * milestone;

@end
