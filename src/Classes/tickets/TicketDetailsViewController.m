//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDetailsViewController.h"

@implementation TicketDetailsViewController

- (void)dealloc {
    [headerView release];
    [editTicketViewController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [self.navigationItem setRightBarButtonItem:self.editButtonItem
        animated:NO];

    self.tableView.tableHeaderView = headerView;
}

#pragma mark UITableViewController implementation

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // customized editing, don't call super

    [self presentModalViewController:self.editTicketViewController
        animated:animated];
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    return @"Comments and changes";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CommentTableViewCell";
    
    UITableViewCell * cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }
    
    // Set up the cell...

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 136;
}

- (void)setTicketNumber:(NSUInteger)aNumber ticket:(Ticket *)aTicket
{
    self.navigationItem.title =
        [NSString stringWithFormat:@"Ticket %d", aNumber];
}

#pragma mark TicketDetailsViewController implementation

- (EditTicketViewController *)editTicketViewController
{
    if (!editTicketViewController)
        editTicketViewController =
            [[EditTicketViewController alloc]
            initWithNibName:@"EditTicketView" bundle:nil];

    return editTicketViewController;
}

@end
