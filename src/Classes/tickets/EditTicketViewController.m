//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "EditTicketViewController.h"
#import "UIColor+BugWatchColors.h"
#import "EditTicketTableViewCell.h"

enum EditTicketCell
{
    kAssignedTo,
    kMilestone,
    kState
};

@implementation EditTicketViewController

- (void)dealloc
{
    [tableView release];
    [headerView release];
    [footerView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = footerView;
    tableView.backgroundColor = [UIColor bugWatchBackgroundColor];
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
    return 3;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"EditTicketTableViewCell";
    
    EditTicketTableViewCell * cell =
        (EditTicketTableViewCell *)
        [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"EditTicketTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    switch (indexPath.row) {
        case kAssignedTo:
            [cell setKeyText:@"assigned to"];
            [cell setValueText:@"Doug Kurth"];
            break;
        case kMilestone:
            [cell setKeyText:@"milestone"];
            [cell setValueText:@"1.1.0"];
            break;
        case kState:
            [cell setKeyText:@"state"];
            [cell setValueText:@"resolved"];
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark EditTicketViewController implementation

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
