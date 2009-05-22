//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestonesViewController.h"
#import "MilestonesTableViewCell.h"
#import "Milestone.h"
#import "NSArray+IterationAdditions.h"
#import "UITableViewCell+InstantiationAdditions.h"

@interface MilestonesViewController ()

- (Milestone *)milestoneAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)effectiveSectionForSection:(NSInteger)section;

@end

@implementation MilestonesViewController

@synthesize delegate, milestones, projects;

- (void)dealloc
{
    [milestones release];
    [projects release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    NSInteger nsections = 0;

    for (id projectKey in self.milestones)
        nsections += [[self.milestones objectForKey:projectKey] count] ? 1 : 0;

    return nsections;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    section = [self effectiveSectionForSection:section];
    id projectKey = [self.projects.allKeys objectAtIndex:section];
    return [[self.milestones objectForKey:projectKey] count];
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    section = [self effectiveSectionForSection:section];

    id key = [self.projects.allKeys objectAtIndex:section];
    return [[self.projects objectForKey:key] name];
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

    cell.milestone = [self milestoneAtIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate userDidSelectMilestone:[self milestoneAtIndexPath:indexPath]];
}

#pragma mark Updating the display

- (void)updateDisplay
{
    [self.tableView reloadData];
}

#pragma mark Helper methods

- (Milestone *)milestoneAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [self effectiveSectionForSection:indexPath.section];

    id projectKey = [self.projects.allKeys objectAtIndex:section];
    Milestone * milestone =
        [[self.milestones objectForKey:projectKey] objectAtIndex:indexPath.row];

    return milestone;
}

- (NSInteger)effectiveSectionForSection:(NSInteger)section
{
    NSInteger effectiveSection = section;

    NSArray * projectKeys = self.projects.allKeys;
    for (NSInteger i = 0; i <= effectiveSection; ++i) {
        id projectKey = [projectKeys objectAtIndex:i];
        NSArray * projectMilestones = [self.milestones objectForKey:projectKey];

        if (projectMilestones.count == 0)
            ++effectiveSection;
    }

    return effectiveSection;
}

@end
