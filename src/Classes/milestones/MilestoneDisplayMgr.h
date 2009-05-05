//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"
#import "MilestonesViewControllerDelegate.h"

@class MilestonesViewController;

@interface MilestoneDisplayMgr :
    NSObject
    <NetworkAwareViewControllerDelegate, MilestonesViewControllerDelegate>
{
    NetworkAwareViewController * networkAwareViewController;
    MilestonesViewController * milestonesViewController;
}

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc;

@end
