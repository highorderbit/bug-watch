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

    NSDictionary * projects;
}

@property (nonatomic, assign) id<MilestonesViewControllerDelegate> delegate;
@property (nonatomic, copy, readonly) NSDictionary * projects;

- (NSArray *)milestones;

- (void)updateDisplayWithMilestones:(NSArray *)someMilestones
                           projects:(NSDictionary *)someProjects;

@end
