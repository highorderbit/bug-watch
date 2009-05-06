//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"
#import "MilestonesViewControllerDelegate.h"

@class MilestonesViewController, MilestoneViewController;

@interface MilestoneDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, MilestonesViewControllerDelegate>
{
    UINavigationController * navigationController;
    NetworkAwareViewController * networkAwareViewController;
    MilestonesViewController * milestonesViewController;

    MilestoneViewController * milestoneViewController;
}

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc;

@end
