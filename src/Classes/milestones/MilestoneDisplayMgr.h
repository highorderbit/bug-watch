//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"
#import "MilestonesViewControllerDelegate.h"
#import "MilestoneDataSourceDelegate.h"

@class MilestoneDataSource, MilestonesViewController;
@class MilestoneDetailsDisplayMgr;

@interface MilestoneDisplayMgr :
    NSObject
    <MilestoneDataSourceDelegate, NetworkAwareViewControllerDelegate,
    MilestonesViewControllerDelegate>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    MilestonesViewController * milestonesViewController;

    MilestoneDataSource * milestoneDataSource;

    MilestoneDetailsDisplayMgr * milestoneDetailsDisplayMgr;

    NSArray * milestones;
    NSArray * milestoneKeys;
    NSArray * projectKeys;
}

#pragma mark Initialization

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
                     milestoneDataSource:(MilestoneDataSource *)dataSource
              milestoneDetailsDisplayMgr:(MilestoneDetailsDisplayMgr *)mddm;

@end
