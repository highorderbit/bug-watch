//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDetailsDisplayMgr.h"
#import "MilestoneDetailsDataSource.h"
#import "NetworkAwareViewController.h"
#import "TicketsViewController.h"
#import "MilestoneHeaderView.h"
#import "Milestone.h"
#import "TicketMetaData.h"

@interface MilestoneDetailsDisplayMgr ()

- (void)updateDisplay;

@property (nonatomic, retain) NetworkAwareViewController *
    networkAwareViewController;
@property (nonatomic, retain) TicketsViewController * ticketsViewController;
@property (nonatomic, retain) MilestoneHeaderView * milestoneHeaderView;
@property (nonatomic, retain) UISegmentedControl * ticketFilterControl;

@property (nonatomic, copy) Milestone * milestone;
@property (nonatomic, copy) id milestoneKey;
@property (nonatomic, copy) id projectKey;

@property (nonatomic, copy) NSDictionary * tickets;
@property (nonatomic, copy) NSDictionary * metadata;
@property (nonatomic, copy) NSDictionary * userIds;
@property (nonatomic, copy) NSDictionary * creatorIds;

@end

@implementation MilestoneDetailsDisplayMgr

@synthesize networkAwareViewController, ticketsViewController;
@synthesize milestoneHeaderView, ticketFilterControl;
@synthesize milestone, milestoneKey, projectKey;
@synthesize tickets, metadata, userIds, creatorIds;

- (void)dealloc
{
    [networkAwareViewController release];
    [ticketsViewController release];
    [milestoneHeaderView release];
    [ticketFilterControl release];

    [detailsDataSource release];

    [milestone release];
    [milestoneKey release];
    [projectKey release];

    [tickets release];
    [metadata release];
    [userIds release];
    [creatorIds release];

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

    [networkAwareViewController setCachedDataAvailable:NO];
    [navController
        pushViewController:self.networkAwareViewController animated:YES];
}

- (void)updateDisplay
{
    NSMutableDictionary * milestones = [NSMutableDictionary dictionary];
    for (id ticketKey in tickets)
        [milestones setObject:self.milestone.name forKey:ticketKey];

    NSMutableDictionary * filteredTickets = [tickets mutableCopy];
    NSUInteger filter = self.ticketFilterControl.selectedSegmentIndex == 0 ?
        (kNew | kOpen) :
        (kResolved | kHold | kInvalid);

    for (id ticketKey in tickets) {
        TicketMetaData * md = [metadata objectForKey:ticketKey];
        if (!(md.state & filter))
            [filteredTickets removeObjectForKey:ticketKey];
    }

    // Note that only the tickets are filtered; metadata, users, milestones,
    // etc. contain keys for every ticket. Consider revising if necessary.
    [self.ticketsViewController
        setTickets:filteredTickets metaData:metadata assignedToDict:userIds
        milestoneDict:milestones];

    self.milestoneHeaderView.milestone = self.milestone;
    self.ticketsViewController.headerView = self.milestoneHeaderView;

    [networkAwareViewController setCachedDataAvailable:YES];
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    networkAwareViewController.navigationItem.titleView =
        self.ticketFilterControl;
    ticketFilterControl.selectedSegmentIndex = 0;

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

- (void)tickets:(NSDictionary *)someTickets fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString metadata:(NSDictionary *)someMetadata
    milestone:(Milestone *)aMilestone userIds:(NSDictionary *)someUserIds
    creatorIds:(NSDictionary *)someCreatorIds
{
    self.milestone = aMilestone;
    self.tickets = someTickets;
    self.metadata = someMetadata;
    self.userIds = someUserIds;
    self.creatorIds = someCreatorIds;

    [self updateDisplay];
}

- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString error:(NSError *)error
{
}

#pragma mark UISegmentedControl actions

- (void)ticketFilterDidChange:(id)sender
{
    [self updateDisplay];
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

    //return milestoneHeaderView;
    return nil;
}

- (UISegmentedControl *)ticketFilterControl
{
    if (!ticketFilterControl) {
        NSArray * items =
            [NSArray arrayWithObjects:
            NSLocalizedString(@"milestonedetails.tickets.filter.active", @""),
            NSLocalizedString(@"milestonedetails.tickets.filter.inactive", @""),
            nil];

        ticketFilterControl =
            [[UISegmentedControl alloc] initWithItems:items];
        ticketFilterControl.segmentedControlStyle = UISegmentedControlStyleBar;

        [ticketFilterControl addTarget:self
                                action:@selector(ticketFilterDidChange:)
                      forControlEvents:UIControlEventValueChanged];
    }

    return ticketFilterControl;
}

@end
