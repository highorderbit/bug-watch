//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MilestonesViewControllerDelegate.h"

@interface MilestonesViewController : UITableViewController
{
    id<MilestonesViewControllerDelegate> delegate;

    NSArray * openMilestones;
    NSArray * completedMilestones;
}

@property (nonatomic, assign) id<MilestonesViewControllerDelegate> delegate;

- (void)setMilestones:(NSArray *)milestones;
- (NSArray *)milestones;

@end