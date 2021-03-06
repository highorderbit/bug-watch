//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketsViewController.h"
#import "Ticket.h"
#import "TicketMetaData.h"
#import "TicketTableViewCell.h"
#import "LighthouseKey.h"
#import "UIColor+BugWatchColors.h"

@interface TicketsViewController (Private)

- (NSArray *)sortedKeys;

@end

@implementation TicketsViewController

@synthesize delegate, headerView, sortedKeyCache;

- (void)dealloc
{
    [delegate release];
    
    [tickets release];
    [metaData release];
    [assignedToDict release];
    [milestoneDict release];
    [resolvingDict release];

    [headerView release];
    [noneFoundView release];
    [loadMoreView release];
    [loadMoreButton release];
    [currentPagesLabel release];
    [noMorePagesLabel release];
    
    [sortedKeyCache release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [loadMoreButton setTitleColor:[UIColor bugWatchBlueColor]
        forState:UIControlStateNormal];
    [self setAllPagesLoaded:NO];
    resolvingDict = [[NSMutableDictionary dictionary] retain];
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
    static NSString * cellIdentifier = @"TicketTableViewCell";
    
    TicketTableViewCell * cell =
        (TicketTableViewCell *)
        [aTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"TicketTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    LighthouseKey * ticketKey = [[self sortedKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketKey];
    TicketMetaData * ticketMetaData =
        [metaData objectForKey:ticketKey];
    [cell setNumber:ticketKey.key];
    [cell setState:ticketMetaData.state];
    [cell setDescription:ticket.description];
    [cell setLastUpdatedDate:ticketMetaData.lastModifiedDate];
    NSString * assignedToName = [assignedToDict objectForKey:ticketKey];
    assignedToName = assignedToName ? assignedToName : @"none";
    [cell setAssignedToName:assignedToName];
    NSString * milestoneName = [milestoneDict objectForKey:ticketKey];
    milestoneName = milestoneName ? milestoneName : @"none";
    [cell setMilestoneName:milestoneName];

    if ([resolvingDict objectForKey:ticketKey])
        [cell disableView];
    else
        [cell enableView];
    cell.selectionStyle =
        ![resolvingDict objectForKey:ticketKey] ?
        UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LighthouseKey * key = [[self sortedKeys] objectAtIndex:indexPath.row];

    return !![resolvingDict objectForKey:key] ? nil : indexPath;
}

- (void)tableView:(UITableView *)aTableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LighthouseKey * key = [[self sortedKeys] objectAtIndex:indexPath.row];
    [delegate selectedTicketKey:key];
}

- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    LighthouseKey * key = [[self sortedKeys] objectAtIndex:indexPath.row];
    TicketMetaData * ticketMetaData = [metaData objectForKey:key];

    return ticketMetaData.state != kResolved;
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        LighthouseKey * key = [[self sortedKeys] objectAtIndex:indexPath.row];
        NSLog(@"Setting ticket state to resolved for ticket %@...", key);
        [resolvingDict setObject:self forKey:key];
        [delegate resolveTicketWithKey:key];
        [self.tableView performSelector:@selector(reloadData)
            withObject:nil afterDelay:0.2];
    }
}

#pragma mark UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * ticketNumber = [[self sortedKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketNumber];
    
    return [TicketTableViewCell heightForContent:ticket.description];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
    editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark TicketsViewController implementation

- (void)setTickets:(NSDictionary *)someTickets
    metaData:(NSDictionary *)someMetaData
    assignedToDict:(NSDictionary *)anAssignedToDict
    milestoneDict:(NSDictionary *)aMilestoneDict
    page:(NSUInteger)page
{
    self.sortedKeyCache = nil;

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

    [resolvingDict removeAllObjects];

    self.tableView.tableFooterView =
        [someTickets count] > 0 ? loadMoreView : noneFoundView;

    NSString * showingMultPagesFormatString =
        NSLocalizedString(@"ticketsview.showingmultiplepages", @"");
    NSString * showingSinglePageFormatString =
        NSLocalizedString(@"ticketsview.showingsinglepage", @"");
    currentPagesLabel.text =
        page > 1 ?
        [NSString stringWithFormat:showingMultPagesFormatString, page] :
        showingSinglePageFormatString;

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
    if (!self.sortedKeyCache)
        self.sortedKeyCache =
            [metaData keysSortedByValueUsingSelector:@selector(compare:)];

    return sortedKeyCache;
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
