//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestonesViewController.h"
#import "MilestonesTableViewCell.h"
#import "Milestone.h"

@implementation MilestonesViewController

@synthesize delegate, milestones;

- (void)dealloc
{
    [milestones release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    milestones = [[Milestone dummyData] retain];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    return milestones.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"MilestonesTableViewCell";

    MilestonesTableViewCell * cell = (MilestonesTableViewCell *)
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
        cell = [MilestonesTableViewCell createCustomInstance];

    cell.milestone = [milestones objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate userDidSelectMilestone:[milestones objectAtIndex:indexPath.row]];
}

- (void)setMilestones:(NSArray *)someMilestones
{
    NSArray * tmp = [someMilestones copy];
    [milestones release];
    milestones = tmp;

    [self.tableView reloadData];
}

@end
