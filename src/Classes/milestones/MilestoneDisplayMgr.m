//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDisplayMgr.h"
#import "MilestonesViewController.h"
#import "MilestoneDataSource.h"
#import "MilestoneDetailsDisplayMgr.h"
#import "Milestone.h"
#import "NSArray+IterationAdditions.h"

@interface MilestoneDisplayMgr ()

- (void)updateDisplay;

@property (nonatomic, retain) UISegmentedControl * milestoneFilterControl;

@property (nonatomic, copy) NSArray * milestones;
@property (nonatomic, copy) NSArray * milestoneKeys;
@property (nonatomic, copy) NSArray * milestoneProjectKeys;
@property (nonatomic, copy) NSDictionary * allProjects;

@end

@implementation MilestoneDisplayMgr

@synthesize milestoneFilterControl;
@synthesize milestones, milestoneKeys, allProjects, milestoneProjectKeys;

- (void)dealloc
{
    [navigationController release];
    [networkAwareViewController release];
    [milestonesViewController release];

    [milestoneFilterControl release];

    [milestoneDataSource release];

    [milestoneDetailsDisplayMgr release];

    self.milestones = nil;
    self.milestoneKeys = nil;
    self.milestoneProjectKeys = nil;
    self.allProjects = nil;

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

        self.milestoneFilterControl.selectedSegmentIndex = 0;
        networkAwareViewController.navigationItem.titleView =
            self.milestoneFilterControl;
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
    id projectKey = [self.milestoneProjectKeys objectAtIndex:idx];

    [milestoneDetailsDisplayMgr
        displayDetailsForMilestone:milestone withMilestoneKey:milestoneKey
        projectKey:projectKey navigationController:navigationController];
}

#pragma mark UISegmentedControl actions

- (void)milestoneFilterDidChange:(id)sender
{
    [self updateDisplay];
}

#pragma mark Updating the display

- (void)updateDisplay
{
    BOOL dataAvailable = self.milestones && self.allProjects;

    if (dataAvailable)
        [milestonesViewController updateDisplayWithMilestones:self.milestones
                                                     projects:self.allProjects];

    [networkAwareViewController setCachedDataAvailable:dataAvailable];
}

#pragma mark MilestoneDataSourceDelegate implementation

- (void)fetchDidBegin
{
    [networkAwareViewController setUpdatingState:kConnectedAndUpdating];
}

- (void)fetchDidEnd
{
    [networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)fetchFailedWithError:(NSError *)error
{
    NSLog(@"Failed to fetch milestiones: '%@'.", error);
}

- (void)currentMilestonesForAllProjects:(NSArray *)someMilestones
                          milestoneKeys:(NSArray *)someMilestoneKeys
                            projectKeys:(NSArray *)someProjectKeys
{
    self.milestones = someMilestones;
    self.milestoneKeys = someMilestoneKeys;
    self.milestoneProjectKeys = someProjectKeys;

    [self updateDisplay];
}

- (void)currentProjects:(NSArray *)someProjects
            projectKeys:(NSArray *)someProjectKeys
{
    self.allProjects = [NSDictionary dictionaryWithObjects:someProjects
                                                   forKeys:someProjectKeys];

    [self updateDisplay];
}

#pragma mark Accessors

- (UISegmentedControl *)milestoneFilterControl
{
    if (!milestoneFilterControl) {
        NSArray * items =
            [NSArray arrayWithObjects:
            NSLocalizedString(@"milestones.filter.active", @""),
            NSLocalizedString(@"milestones.filter.inactive", @""),
            nil];

        milestoneFilterControl =
            [[UISegmentedControl alloc] initWithItems:items];
        milestoneFilterControl.segmentedControlStyle =
            UISegmentedControlStyleBar;

        [milestoneFilterControl addTarget:self
                                action:@selector(milestoneFilterDidChange:)
                      forControlEvents:UIControlEventValueChanged];
    }

    return milestoneFilterControl;
}

@end