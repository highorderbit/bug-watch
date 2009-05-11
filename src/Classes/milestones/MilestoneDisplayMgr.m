//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDisplayMgr.h"
#import "MilestonesViewController.h"
#import "MilestoneViewController.h"
#import "MilestoneDataSource.h"
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

    [milestoneDataSource release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
                     milestoneDataSource:(MilestoneDataSource *)dataSource
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

        milestoneDataSource = [dataSource retain];
        milestoneDataSource.delegate = self;

        UIBarButtonItem * refreshButton =
            [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
            target:self
            action:@selector(userDidRequestRefresh)];
        networkAwareViewController.navigationItem.rightBarButtonItem =
            refreshButton;
        [refreshButton release];
    }

    return self;
}

- (void)userDidRequestRefresh
{
    [milestoneDataSource refreshMilestones];
    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    NSArray * milestones = [milestoneDataSource currentMilestones];
    milestonesViewController.milestones = milestones;

    [networkAwareViewController setCachedDataAvailable:!!milestones];

    BOOL updating = [milestoneDataSource fetchMilestonesIfNecessary];
    [networkAwareViewController
        setUpdatingState:
        updating ? kConnectedAndUpdating : kConnectedAndNotUpdating];
}

#pragma mark MilestonesViewControllerDelegate implementation

- (void)userDidSelectMilestone:(Milestone *)milestone
{
    NSLog(@"User selected milestone: '%@'.", milestone);

    [self milestoneViewController].navigationItem.title = milestone.name;
    [navigationController
        pushViewController:[self milestoneViewController] animated:YES];
}

#pragma mark MilestoneDataSourceDelegate implementation

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones
{
    milestonesViewController.milestones = milestones;
    [networkAwareViewController setCachedDataAvailable:YES];
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)failedToFetchMilestonesForAllProjects:(NSError *)error
{
    NSLog(@"Failed to fetch milestiones: '%@'.", error);
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
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
