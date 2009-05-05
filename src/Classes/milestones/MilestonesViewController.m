//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestonesViewController.h"
#import "MilestonesTableViewCell.h"
#import "Milestone.h"

@implementation MilestonesViewController

@synthesize milestones;

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

- (void)          tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController =
    //     [[AnotherViewController alloc]
    //      initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}

@end
