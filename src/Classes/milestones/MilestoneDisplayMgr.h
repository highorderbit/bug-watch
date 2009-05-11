//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"
#import "MilestonesViewControllerDelegate.h"
#import "MilestoneDataSourceDelegate.h"

@class MilestoneDataSource;
@class MilestonesViewController, MilestoneViewController;

@interface MilestoneDisplayMgr :
    NSObject
    <MilestoneDataSourceDelegate, NetworkAwareViewControllerDelegate,
    MilestonesViewControllerDelegate>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    MilestonesViewController * milestonesViewController;

    MilestoneViewController * milestoneViewController;

    MilestoneDataSource * milestoneDataSource;
}

#pragma mark Initialization

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
                     milestoneDataSource:(MilestoneDataSource *)dataSource;

@end
