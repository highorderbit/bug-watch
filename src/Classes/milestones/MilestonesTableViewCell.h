//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+InstantiationAdditions.h"

@class Milestone;

@interface MilestonesTableViewCell : UITableViewCell
{
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * dueDateLabel;
    IBOutlet UILabel * numOpenTicketsLabel;
    IBOutlet UILabel * numOpenTicketsTitleLabel;
    IBOutlet UIProgressView * progressView;

    Milestone * milestone;
}

@property (nonatomic, copy) Milestone * milestone;

@end
