//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDisplayMgr.h"
#import "MilestonesViewController.h"
#import "MilestoneViewController.h"
#import "MilestoneDataSource.h"
#import "MilestoneDetailsDisplayMgr.h"
#import "Milestone.h"
#import "NSArray+IterationAdditions.h"

@interface MilestoneDisplayMgr ()

@property (nonatomic, copy) NSArray * milestones;
@property (nonatomic, copy) NSArray * milestoneKeys;
@property (nonatomic, copy) NSArray * projectKeys;

@end

@implementation MilestoneDisplayMgr

@synthesize milestones, milestoneKeys, projectKeys;

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [milestonesViewController release];

    [milestoneDataSource release];

    [milestoneDetailsDisplayMgr release];

    self.milestones = nil;
    self.milestoneKeys = nil;
    self.projectKeys = nil;

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
                     milestoneDataSource:(MilestoneDataSource *)dataSource
              milestoneDetailsDisplayMgr:(MilestoneDetailsDisplayMgr *)mddm
{
    if (self = [super init]) {
        networkAwareViewController = [navc retain];
        networkAwareViewController.delegate = self;
        [networkAwareViewController
            setNoConnectionText:
            NSLocalizedString(@"milestones.view.nodata", @"")];

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

        milestoneDetailsDisplayMgr = [mddm retain];

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
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    [milestoneDataSource fetchMilestonesIfNecessary];
}

#pragma mark MilestonesViewControllerDelegate implementation

- (void)userDidSelectMilestone:(Milestone *)milestone
{
    NSLog(@"User selected milestone: '%@'.", milestone);

    NSInteger idx = [self.milestones indexOfObject:milestone];
    NSAssert2(idx != NSNotFound, @"User selected unknown milestone: '%@'; I "
        "know about these milestones: '%@'.", self.milestones, milestone);

    id milestoneKey = [self.milestoneKeys objectAtIndex:idx];
    id projectKey = [self.projectKeys objectAtIndex:idx];

    [milestoneDetailsDisplayMgr
        displayDetailsForMilestone:milestone withMilestoneKey:milestoneKey
        projectKey:projectKey navigationController:navigationController];
}

#pragma mark MilestoneDataSourceDelegate implementation

- (void)currentMilestonesForAllProjects:(NSArray *)someMilestones
                          milestoneKeys:(NSArray *)someMilestoneKeys
                            projectKeys:(NSArray *)someProjectKeys
{
    [self milestonesFetchedForAllProjects:someMilestones
                            milestoneKeys:someMilestoneKeys
                              projectKeys:someProjectKeys];
}

- (void)milestoneFetchDidBegin
{
    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
}

- (void)milestoneFetchDidEnd
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)milestonesFetchedForAllProjects:(NSArray *)someMilestones
                          milestoneKeys:(NSArray *)someMilestoneKeys
                            projectKeys:(NSArray *)someProjectKeys
{
    self.milestones = someMilestones;
    self.milestoneKeys = someMilestoneKeys;
    self.projectKeys = someProjectKeys;

    milestonesViewController.milestones = self.milestones;

    [networkAwareViewController setCachedDataAvailable:
        !!milestones && milestones.count > 0];
}

- (void)failedToFetchMilestonesForAllProjects:(NSError *)error
{
    NSLog(@"Failed to fetch milestiones: '%@'.", error);
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

@end
