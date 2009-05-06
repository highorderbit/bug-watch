//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDisplayMgr.h"
#import "MilestonesViewController.h"
#import "MilestoneViewController.h"
#import "Milestone.h"

@interface MilestoneDisplayMgr ()

- (MilestoneViewController *)milestoneViewController;

@end

@implementation MilestoneDisplayMgr

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [milestonesViewController release];

    [milestoneViewController release];

    [super dealloc];
}

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
{
    if (self = [super init]) {
        networkAwareViewController = [navc retain];
        networkAwareViewController.delegate = self;

        navigationController = 
            [networkAwareViewController.navigationController retain];

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

    [self milestoneViewController].navigationItem.title = milestone.name;
    [navigationController
        pushViewController:[self milestoneViewController] animated:YES];
}

#pragma mark Accessors

- (MilestoneViewController *)milestoneViewController
{
    if (!milestoneViewController)
        milestoneViewController =
            [[MilestoneViewController alloc]
            initWithNibName:@"MilestoneView" bundle:nil];

    return milestoneViewController;
}

@end
