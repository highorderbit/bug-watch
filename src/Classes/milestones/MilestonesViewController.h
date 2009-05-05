//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MilestonesViewControllerDelegate.h"

@interface MilestonesViewController : UITableViewController
{
    id<MilestonesViewControllerDelegate> delegate;

    NSArray * milestones;
}

@property (nonatomic, assign) id<MilestonesViewControllerDelegate> delegate;
@property (nonatomic, readonly, copy) NSArray * milestones;

@end
