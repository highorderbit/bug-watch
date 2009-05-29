//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketTableViewCell : UITableViewCell
{
    IBOutlet UILabel * numberLabel;
    IBOutlet UILabel * stateLabel;
    IBOutlet UILabel * lastUpdatedLabel;
    IBOutlet UILabel * descriptionLabel;
    IBOutlet UILabel * assignedToLabel;
    IBOutlet UILabel * milestoneLabel;
    IBOutlet UIButton * resolveButton;
    UIColor * stateLabelColor;
}

- (void)setNumber:(NSUInteger)number;
- (void)setState:(NSUInteger)state;
- (void)setLastUpdatedDate:(NSDate *)lastUpdatedDate;
- (void)setDescription:(NSString *)description;
- (void)setAssignedToName:(NSString *)assignedToName;
- (void)setMilestoneName:(NSString *)milestoneName;
+ (CGFloat)heightForContent:(NSString *)description;

@end
