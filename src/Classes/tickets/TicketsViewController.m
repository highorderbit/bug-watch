//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketsViewController.h"
#import "Ticket.h"
#import "TicketMetaData.h"
#import "TicketTableViewCell.h"

@implementation TicketsViewController

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    
    [tickets release];
    [metaData release];
    [assignedToDict release];
    [milestoneDict release];

    [footerView release];

    [super dealloc];
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

    NSNumber * ticketNumber = [[tickets allKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketNumber];
    TicketMetaData * ticketMetaData =
        [metaData objectForKey:ticketNumber];
    [cell setNumber:[ticketNumber intValue]];
    [cell setState:ticketMetaData.state];
    [cell setDescription:ticket.description];
    [cell setLastUpdatedDate:ticketMetaData.lastModifiedDate];
    NSString * assignedToName = [assignedToDict objectForKey:ticketNumber];
    assignedToName = assignedToName ? assignedToName : @"none";
    [cell setAssignedToName:assignedToName];
    NSString * milestoneName = [milestoneDict objectForKey:ticketNumber];
    milestoneName = milestoneName ? milestoneName : @"none";
    [cell setMilestoneName:milestoneName];

    return cell;
}

- (void)tableView:(UITableView *)aTableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger number =
        [[[tickets allKeys] objectAtIndex:indexPath.row] intValue];
    [delegate selectedTicketNumber:number];
}

#pragma mark UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * ticketNumber = [[tickets allKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketNumber];
    
    return [TicketTableViewCell heightForContent:ticket.description];
}

#pragma mark TicketsViewController implementation

- (void)setTickets:(NSDictionary *)someTickets
    metaData:(NSDictionary *)someMetaData
    assignedToDict:(NSDictionary *)anAssignedToDict
    milestoneDict:(NSDictionary *)aMilestoneDict
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
    
    self.tableView.tableFooterView = [someTickets count] > 0 ? nil : footerView;
        
    [self.tableView reloadData];
}

@end

