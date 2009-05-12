//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneViewController.h"
#import "Milestone.h"
#import "MilestoneProgressView.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface MilestoneViewController ()

- (void)updateDisplay;

@end

@implementation MilestoneViewController

@synthesize milestone;

- (void)dealloc
{
    [headerView release];

    [nameLabel release];
    [dueDateLabel release];
    [goalsLabel release];

    [numOpenTicketsView release];
    [numOpenTicketsLabel release];
    [numOpenTicketsTitleLabel release];
    [numOpenTicketsViewBackgroundColor release];

    [progressView release];

    [milestone release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView = headerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateDisplay];
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
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"milestone.tickets.section.title", @"");
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";

    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
        cell =
            [[[UITableViewCell alloc]
              initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
             autorelease];

    return cell;
}

- (void)tableView:(UITableView *)tv
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController =
    //     [[AnotherViewController alloc]
    //      initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}

- (void)updateDisplay
{
    nameLabel.text = milestone.name;
    if (milestone.dueDate)
        dueDateLabel.text =
            [NSString stringWithFormat:
            NSLocalizedString(@"milestones.due.future.formatstring", @""),
            [milestone.dueDate shortDateDescription]];
    else
        dueDateLabel.text =
            NSLocalizedString(@"milestones.due.never.formatstring", @"");

    numOpenTicketsLabel.text =
        [NSString stringWithFormat:@"%u", milestone.numOpenTickets];
    numOpenTicketsTitleLabel.text =
        milestone.numOpenTickets == 1 ?
        NSLocalizedString(@"milestones.tickets.open.count.label.singular",
        @"") :
        NSLocalizedString(@"milestones.tickets.open.count.label.plural", @"");

    if (milestone.numTickets == 0)
        progressView.progress = 0.0;
    else
        progressView.progress =
            ((float) milestone.numTickets - milestone.numOpenTickets) /
            (float) milestone.numTickets;

    goalsLabel.text = milestone.goals;
    CGFloat amountToGrow = [goalsLabel sizeVerticallyToFit];

    CGRect headerViewFrame = headerView.frame;
    headerViewFrame.size.height = headerViewFrame.size.height + amountToGrow;
    headerView.frame = headerViewFrame;
    self.tableView.tableHeaderView = headerView;

    [self.tableView reloadData];
}

#pragma mark Accessors

- (void)setMilestone:(Milestone *)aMilestone
{
    Milestone * tmp = [aMilestone copy];
    [milestone release];
    milestone = tmp;

    [self updateDisplay];
}

@end
