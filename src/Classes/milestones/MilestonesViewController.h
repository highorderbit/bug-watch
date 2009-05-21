//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MilestonesViewControllerDelegate.h"

@interface MilestonesViewController : UITableViewController
{
    id<MilestonesViewControllerDelegate> delegate;

    NSDictionary * milestones;
    NSDictionary * projects;
}

@property (nonatomic, assign) id<MilestonesViewControllerDelegate> delegate;

@property (nonatomic, copy) NSDictionary * milestones;
@property (nonatomic, copy) NSDictionary * projects;

- (void)updateDisplay;

@end
