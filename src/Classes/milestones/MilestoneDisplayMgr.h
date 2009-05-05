//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAwareViewController.h"

@class MilestonesViewController;

@interface MilestoneDisplayMgr : NSObject <NetworkAwareViewControllerDelegate>
{
    NetworkAwareViewController * networkAwareViewController;
    MilestonesViewController * milestonesViewController;
}

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc;

@end
