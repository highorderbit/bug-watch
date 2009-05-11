//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestonesViewController.h"
#import "MilestonesTableViewCell.h"
#import "Milestone.h"
#import "NSArray+IterationAdditions.h"

static const NSInteger NUM_SECTIONS = 2;
enum Sections
{
    kOpenMilestonesSection,
    kCompletedMilestonesSection
};

@interface MilestonesViewController ()

- (NSArray *)extractOpenMilestones:(NSArray *)milestones;
- (NSArray *)extractCompletedMilestones:(NSArray *)milestones;

- (NSInteger)effectiveSectionForSection:(NSInteger)section;

@property (nonatomic, copy) NSArray * openMilestones;
@property (nonatomic, copy) NSArray * completedMilestones;

@end

@implementation MilestonesViewController

@synthesize delegate, openMilestones, completedMilestones;

- (void)dealloc
{
    [openMilestones release];
    [completedMilestones release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.milestones = [[Milestone dummyData] retain];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv
{
    NSInteger nsections = NUM_SECTIONS;

    if (openMilestones.count == 0)
        --nsections;
    if (completedMilestones.count == 0)
        --nsections;

    // required to return at least 1 section
    return nsections == 0 ? 1 : nsections;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger nrows = 0;

    NSInteger effectiveSection = [self effectiveSectionForSection:section];
    switch (effectiveSection) {
        case kOpenMilestonesSection:
            nrows = openMilestones.count;
            break;
        case kCompletedMilestonesSection:
            nrows = completedMilestones.count;
            break;
    }

    return nrows;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    NSString * title = nil;

    NSInteger effectiveSection = [self effectiveSectionForSection:section];
    switch (effectiveSection) {
        case kOpenMilestonesSection:
            title = NSLocalizedString(@"milestones.open.section.title", @"");
            break;
        case kCompletedMilestonesSection:
            title =
                NSLocalizedString(@"milestones.completed.section.title", @"");
            break;
    }

    return title;
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

    NSInteger effectiveSection =
        [self effectiveSectionForSection:indexPath.section];
    NSArray * milestones =
        effectiveSection == kOpenMilestonesSection ?
        openMilestones :
        completedMilestones;

    cell.milestone = [milestones objectAtIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate userDidSelectMilestone:
        [[self milestones] objectAtIndex:indexPath.row]];
}

- (NSArray *)milestones
{
    return [openMilestones arrayByAddingObjectsFromArray:completedMilestones];
}

- (void)setMilestones:(NSArray *)someMilestones
{
    self.openMilestones = [self extractOpenMilestones:someMilestones];
    self.completedMilestones = [self extractCompletedMilestones:someMilestones];

    [self.tableView reloadData];
}

#pragma mark Helper methods

- (NSArray *)extractOpenMilestones:(NSArray *)milestones
{
    NSArray * completed = [self extractCompletedMilestones:milestones];
    NSMutableArray * mutableMilestones = [[milestones mutableCopy] autorelease];
    [mutableMilestones removeObjectsInArray:completed];
    return mutableMilestones;
}

- (NSArray *)extractCompletedMilestones:(NSArray *)milestones
{
    SEL filter = @selector(completed);
    return [milestones arrayByFilteringObjectsUsingSelector:filter];
}

- (NSInteger)effectiveSectionForSection:(NSInteger)section
{
    if (section == kOpenMilestonesSection && openMilestones.count == 0)
        return section + 1;

    return section;
}

@end
