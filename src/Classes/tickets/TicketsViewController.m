//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketsViewController.h"
#import "Ticket.h"
#import "TicketMetaData.h"
#import "TicketTableViewCell.h"
#import "TicketKey.h"
#import "UIColor+BugWatchColors.h"

@interface TicketsViewController (Private)

- (NSArray *)sortedKeys;

@end

@implementation TicketsViewController

@synthesize delegate, headerView;

- (void)dealloc
{
    [delegate release];
    
    [tickets release];
    [metaData release];
    [assignedToDict release];
    [milestoneDict release];

    [headerView release];
    [noneFoundView release];
    [loadMoreView release];
    [loadMoreButton release];
    [currentPagesLabel release];
    [noMorePagesLabel release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [loadMoreButton setTitleColor:[UIColor bugWatchBlueColor]
        forState:UIControlStateNormal];
    [self setAllPagesLoaded:NO];
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView
    numberOfRowsInSection:(NSInteger)section
{
    return [tickets count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TicketTableViewCell";
    
    TicketTableViewCell * cell =
        (TicketTableViewCell *)
        [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"TicketTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    TicketKey * ticketKey = [[self sortedKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketKey];
    TicketMetaData * ticketMetaData =
        [metaData objectForKey:ticketKey];
    [cell setNumber:ticketKey.ticketNumber];
    [cell setState:ticketMetaData.state];
    [cell setDescription:ticket.description];
    [cell setLastUpdatedDate:ticketMetaData.lastModifiedDate];
    NSString * assignedToName = [assignedToDict objectForKey:ticketKey];
    assignedToName = assignedToName ? assignedToName : @"none";
    [cell setAssignedToName:assignedToName];
    NSString * milestoneName = [milestoneDict objectForKey:ticketKey];
    milestoneName = milestoneName ? milestoneName : @"none";
    [cell setMilestoneName:milestoneName];

    return cell;
}

- (void)tableView:(UITableView *)aTableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketKey * key = [[self sortedKeys] objectAtIndex:indexPath.row];
    [delegate selectedTicketKey:key];
}

#pragma mark UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * ticketNumber = [[self sortedKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketNumber];
    
    return [TicketTableViewCell heightForContent:ticket.description];
}

#pragma mark TicketsViewController implementation

- (void)setTickets:(NSDictionary *)someTickets
    metaData:(NSDictionary *)someMetaData
    assignedToDict:(NSDictionary *)anAssignedToDict
    milestoneDict:(NSDictionary *)aMilestoneDict
    page:(NSUInteger)page
{
    NSDictionary * tempTickets = [someTickets copy];
    [tickets release];
    tickets = tempTickets;
    
    NSDictionary * tempMetaData = [someMetaData copy];
    [metaData release];
    metaData = tempMetaData;
    
    NSDictionary * tempAssignedToDict = [anAssignedToDict copy];
    [assignedToDict release];
    assignedToDict = tempAssignedToDict;
    
    NSDictionary * tempMilestoneDict = [aMilestoneDict copy];
    [milestoneDict release];
    milestoneDict = tempMilestoneDict;
    
    self.tableView.tableFooterView =
        [someTickets count] > 0 ? loadMoreView : noneFoundView;

    currentPagesLabel.text =
        page > 1 ?
        [NSString stringWithFormat:@"Showing pages 1 - %d", page] :
        @"Showing page 1";

    [self.tableView reloadData];
}

- (void)setHeaderView:(UIView *)view
{
    [view retain];
    [headerView release];
    headerView = view;

    self.tableView.tableHeaderView = headerView;
    [self.tableView reloadData]; // force the header view to resize
}

- (NSArray *)sortedKeys
{
    return [metaData keysSortedByValueUsingSelector:@selector(compare:)];
}

- (IBAction)loadMoreTickets:(id)sender
{
    [delegate loadMoreTickets];
}

- (void)setAllPagesLoaded:(BOOL)allPagesLoaded
{
    noMorePagesLabel.hidden = !allPagesLoaded;
    loadMoreButton.hidden = allPagesLoaded;
}

@end
