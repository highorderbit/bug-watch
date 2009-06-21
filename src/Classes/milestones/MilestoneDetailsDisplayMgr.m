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

static NSString * STATE_OPEN_STRING = @"open";
static NSString * STATE_CLOSED_STRING = @"closed";

@interface MilestoneDetailsDisplayMgr ()

- (void)updateDisplay;
- (NSString *)buildAppropriateSearchString;
- (NSDictionary *)dictionaryForActiveView;

@property (nonatomic, retain) NetworkAwareViewController *
    networkAwareViewController;
@property (nonatomic, retain) TicketsViewController * ticketsViewController;
@property (nonatomic, retain) MilestoneHeaderView * milestoneHeaderView;
@property (nonatomic, retain) UISegmentedControl * ticketFilterControl;

@property (nonatomic, copy) Milestone * milestone;
@property (nonatomic, copy) id milestoneKey;
@property (nonatomic, copy) id projectKey;

@end

@implementation MilestoneDetailsDisplayMgr

@synthesize networkAwareViewController, ticketsViewController;
@synthesize milestoneHeaderView, ticketFilterControl;
@synthesize milestone, milestoneKey, projectKey;

- (void)dealloc
{
    [networkAwareViewController release];
    [ticketsViewController release];
    [milestoneHeaderView release];
    [ticketFilterControl release];

    [detailsDataSource release];

    [openTicketData release];
    [closedTicketData release];

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

        openTicketData = [[NSMutableDictionary alloc] init];
        closedTicketData = [[NSMutableDictionary alloc] init];
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
    NSDictionary * d = [self dictionaryForActiveView];
    NSDictionary * tickets = [d objectForKey:@"tickets"];
    NSDictionary * metadata = [d objectForKey:@"metadata"];
    NSDictionary * userIds = [d objectForKey:@"userIds"];

    if (tickets) {
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
        [self.ticketsViewController setTickets:filteredTickets
                                      metaData:metadata
                                assignedToDict:userIds
                                 milestoneDict:milestones
                                          page:1 /* TEMPORARY? - set by DNK
                                                    after sig change*/];

        self.milestoneHeaderView.milestone = self.milestone;
        self.ticketsViewController.headerView = self.milestoneHeaderView;
    }

    [networkAwareViewController setCachedDataAvailable:!!tickets];
}

#pragma mark NetworkAwareViewControllerDelegate implementation

- (void)networkAwareViewWillAppear
{
    networkAwareViewController.navigationItem.titleView =
        self.ticketFilterControl;
    ticketFilterControl.selectedSegmentIndex = 0;

    NSString * searchString = [self buildAppropriateSearchString];
    [detailsDataSource fetchIfNecessary:searchString
        milestoneKey:self.milestoneKey projectKey:projectKey];
}

#pragma mark MilestoneDetailsDataSourceDelegate implementation

- (void)fetchDidBegin
{
    NSDictionary * d = [self dictionaryForActiveView];
    [self.networkAwareViewController setCachedDataAvailable:d.count > 0];

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
    // TODO: Check that the milestone is the same before updating the display.

    NSRange where = [searchString rangeOfString:
        [NSString stringWithFormat:@"state:%@", STATE_OPEN_STRING]];
    BOOL open = where.location != NSNotFound;

    NSMutableDictionary * d = open ? openTicketData : closedTicketData;
    [d removeAllObjects];
    [d setObject:someTickets forKey:@"tickets"];
    [d setObject:someMetadata forKey:@"metadata"];
    [d setObject:someUserIds forKey:@"userIds"];
    [d setObject:someCreatorIds forKey:@"creatorIds"];

    [self updateDisplay];
}

- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString errors:(NSArray *)errors
{
    // TODO: Display the error
}

#pragma mark Helper functions

- (NSString *)buildAppropriateSearchString
{
    NSMutableString * s = [NSMutableString stringWithFormat:@"milestone:'%@'",
        milestone.name];

    // Lighthouse recognizes 'open' and 'closed' as special cases. 'open'
    // returns everything that's either new or open, and 'closed' returns
    // everything that's resolved, invalid, or hold.
    [s appendFormat:@"+state:%@",
        self.ticketFilterControl.selectedSegmentIndex == 0 ?
            STATE_OPEN_STRING : STATE_CLOSED_STRING];

    return s;
}

- (NSDictionary *)dictionaryForActiveView
{
    return self.ticketFilterControl.selectedSegmentIndex == 0 ?
        openTicketData : closedTicketData;
}

#pragma mark UISegmentedControl actions

- (void)ticketFilterDidChange:(id)sender
{
    NSString * searchString = [self buildAppropriateSearchString];
    [detailsDataSource fetchIfNecessary:searchString
        milestoneKey:self.milestoneKey projectKey:projectKey];
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
