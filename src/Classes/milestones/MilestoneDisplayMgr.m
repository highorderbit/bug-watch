//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDisplayMgr.h"
#import "MilestonesViewController.h"

@implementation MilestoneDisplayMgr

- (void)dealloc
{
    [networkAwareViewController release];
    [milestonesViewController release];
    [super dealloc];
}

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
{
    if (self = [super init]) {
        networkAwareViewController = [navc retain];
        networkAwareViewController.delegate = self;

        milestonesViewController =
            [[MilestonesViewController alloc]
            initWithNibName:@"MilestonesView" bundle:nil];
        milestonesViewController.delegate = self;
        networkAwareViewController.targetViewController =
            milestonesViewController;
    }

    return self;
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    [networkAwareViewController setCachedDataAvailable:YES];
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

#pragma mark MilestonesViewControllerDelegate implementation

- (void)userDidSelectMilestone:(Milestone *)milestone
{
    NSLog(@"User selected milestone: '%@'.", milestone);
}

@end
