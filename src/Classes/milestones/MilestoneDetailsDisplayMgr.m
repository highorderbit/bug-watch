//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDetailsDisplayMgr.h"
#import "MilestoneDetailsDataSource.h"
#import "NetworkAwareViewController.h"
#import "TicketsViewController.h"
#import "MilestoneHeaderView.h"
#import "Milestone.h"

@interface MilestoneDetailsDisplayMgr ()

@property (nonatomic, copy) Milestone * milestone;
@property (nonatomic, copy) id milestoneKey;
@property (nonatomic, copy) id projectKey;

@property (nonatomic, retain) NetworkAwareViewController *
    networkAwareViewController;
@property (nonatomic, retain) TicketsViewController * ticketsViewController;
@property (nonatomic, retain) MilestoneHeaderView * milestoneHeaderView;

@end

@implementation MilestoneDetailsDisplayMgr

@synthesize milestone, milestoneKey, projectKey;
@synthesize networkAwareViewController, ticketsViewController;
@synthesize milestoneHeaderView;

- (void)dealloc
{
    [networkAwareViewController release];
    [ticketsViewController release];
    [milestoneHeaderView release];

    [detailsDataSource release];

    [milestone release];
    [milestoneKey release];
    [projectKey release];

    [super dealloc];
}

- (id)initWithMilestoneDetailsDataSource:(MilestoneDetailsDataSource *)ds
{
    if (self = [super init]) {
        detailsDataSource = [ds retain];
        detailsDataSource.delegate = self;
    }

    return self;
}

- (void)displayDetailsForMilestone:(Milestone *)aMilestone
                  withMilestoneKey:(id)aMilestoneKey
                      projectKey:(id)aProjectKey
            navigationController:(UINavigationController *)navController
{
    self.milestone = aMilestone;
    self.milestoneKey = aMilestoneKey;
    self.projectKey = aProjectKey;

    self.milestoneHeaderView.milestone = self.milestone;
    self.ticketsViewController.headerView = self.milestoneHeaderView;

    [networkAwareViewController setCachedDataAvailable:NO];
    [navController
        pushViewController:self.networkAwareViewController animated:YES];
}

- (void)networkAwareViewWillAppear
{
    networkAwareViewController.navigationItem.title =
        NSLocalizedString(@"milestonedetails.view.title", @"");
    NSString * searchString =
        [NSString stringWithFormat:@"milestone:'%@'", milestone.name];
    [detailsDataSource fetchIfNecessary:searchString
        milestoneKey:self.milestoneKey projectKey:projectKey];
}

#pragma mark MilestoneDetailsDataSourceDelegate implementation

- (void)fetchDidBegin
{
    [self.networkAwareViewController setUpdatingState:kConnectedAndUpdating];
}

- (void)fetchDidEnd
{
    [self.networkAwareViewController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)tickets:(NSDictionary *)tickets fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString metadata:(NSDictionary *)metadata
    milestone:(Milestone *)aMilestone userIds:(NSDictionary *)userIds
    creatorIds:(NSDictionary *)creatorIds
{
    self.milestone = aMilestone;

    NSDictionary * milestones =
        [NSDictionary dictionaryWithObjectsAndKeys:
        self.milestone, self.milestoneKey, nil];

    [self.ticketsViewController
        setTickets:tickets metaData:metadata assignedToDict:userIds
        milestoneDict:milestones];

    [networkAwareViewController setCachedDataAvailable:YES];
}

- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString error:(NSError *)error
{
}

#pragma mark Accessors

- (NetworkAwareViewController *)networkAwareViewController
{
    if (!networkAwareViewController) {
        networkAwareViewController =
            [[NetworkAwareViewController alloc]
            initWithTargetViewController:self.ticketsViewController];
        networkAwareViewController.delegate = self;
    }

    return networkAwareViewController;
}

- (TicketsViewController *)ticketsViewController
{
    if (!ticketsViewController) {
        ticketsViewController =
            [[TicketsViewController alloc]
            initWithNibName:@"TicketsView" bundle:nil];
    }

    return ticketsViewController;
}

- (MilestoneHeaderView *)milestoneHeaderView
{
    if (!milestoneHeaderView) {
        NSArray * nib =
            [[NSBundle mainBundle]
              loadNibNamed:@"MilestoneHeaderView"
                     owner:self
                   options:nil];

        milestoneHeaderView = [[nib objectAtIndex:0] retain];
    }

    return milestoneHeaderView;
}

@end
