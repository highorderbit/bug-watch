//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "EditTicketViewController.h"
#import "UIColor+BugWatchColors.h"
#import "EditTicketTableViewCell.h"
#import "TicketMetaData.h"
#import "HOTableViewCell.h"

enum EditTicketTableSection
{
    kEditTicketActionSection,
    kEditTicketLabelSection
};

enum EditTicketAction
{
    kAddComment,
    kEditDescription
};

enum EditTicketCell
{
    kAssignedTo,
    kMilestone,
    kState
};

@interface EditTicketViewController (Private)

+ (UITableViewCell *)createCellForSection:(NSUInteger)section;
- (UITableViewCell *)dequeueCellForSection:(NSUInteger)section;

@end

@implementation EditTicketViewController

@synthesize ticketDescription;
@synthesize message;
@synthesize tags;

@synthesize members;
@synthesize member;

@synthesize milestones;
@synthesize milestone;

@synthesize state;

@synthesize comments;

- (void)dealloc
{
    [headerView release];
    [cancelButton release];
    [updateButton release];
    [descriptionTextField release];
    [tagsTextField release];

    [addCommentViewController release];
    [itemSelectionTableViewController release];

    [ticketDescription release];
    [message release];
    [tags release];
    [member release];
    [members release];
    [milestone release];
    [milestones release];
    [comments release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView = headerView;
    self.tableView.backgroundColor = [UIColor bugWatchBackgroundColor];

    [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    [self.navigationItem setRightBarButtonItem:updateButton animated:NO];
    self.navigationItem.title = @"Edit Ticket";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    descriptionTextField.text = self.ticketDescription;
    tagsTextField.text = self.tags;
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return section == kEditTicketActionSection ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self dequeueCellForSection:indexPath.section];
    if (cell == nil)
        cell = [[self class] createCellForSection:indexPath.section];

    if (indexPath.section == kEditTicketActionSection) {
        switch (indexPath.row) {
            case kAddComment:
                cell.text = @"Add comment";
                break;
            case kEditDescription:
                cell.text = @"Edit description";
                break;
        }
    } else {
        EditTicketTableViewCell * editTicketCell =
            (EditTicketTableViewCell *)cell;
        switch (indexPath.row) {
            case kAssignedTo:
                [editTicketCell setKeyText:@"assigned to"];
                NSString * memberName =
                    [self.members objectForKey:self.member];
                [editTicketCell setValueText:memberName];
                break;
            case kMilestone:
                [editTicketCell setKeyText:@"milestone"];
                NSString * milestoneName =
                    [self.milestones objectForKey:self.milestone];
                [editTicketCell setValueText:milestoneName];
                break;
            case kState:
                [editTicketCell setKeyText:@"state"];
                [editTicketCell
                    setValueText:[TicketMetaData descriptionForState:state]];
                break;
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kEditTicketActionSection) {
        switch (indexPath.row) {
            case kAddComment:
                self.addCommentViewController.navigationItem.title =
                    @"Add Comment";
                [self.navigationController
                    pushViewController:self.addCommentViewController
                    animated:YES];
                [self.addCommentViewController setLabelText:@"Add a comment"];
                [self.addCommentViewController setTextViewText:@""];
                break;
            case kEditDescription:
                self.addCommentViewController.navigationItem.title =
                    @"Edit Description";
                [self.navigationController
                    pushViewController:self.addCommentViewController
                    animated:YES];
                [self.addCommentViewController
                    setLabelText:@"Edit description"];
                [self.addCommentViewController
                    setTextViewText:ticketDescription];
                break;
        }
    } else {
        switch (indexPath.row) {
            case kAssignedTo:
                self.itemSelectionTableViewController.navigationItem.title =
                    @"Set Responsible";
                [self.itemSelectionTableViewController
                    setLabelText:@"Who's responsible?"];
                self.itemSelectionTableViewController.selectedItem =
                    self.member;
                [self.itemSelectionTableViewController setItems:self.members];
                [self.navigationController
                    pushViewController:self.itemSelectionTableViewController
                    animated:YES];
                break;
            case kMilestone:
                self.itemSelectionTableViewController.navigationItem.title =
                    @"Set Milestone";
                [self.itemSelectionTableViewController
                    setLabelText:@"Milestone"];
                self.itemSelectionTableViewController.selectedItem =
                    self.milestone;
                [self.itemSelectionTableViewController
                    setItems:self.milestones];
                [self.navigationController
                    pushViewController:self.itemSelectionTableViewController
                    animated:YES];
                break;
            case kState:
                self.itemSelectionTableViewController.navigationItem.title =
                    @"Set State";
                [self.itemSelectionTableViewController
                    setLabelText:@"State"];
                NSMutableDictionary * states = [NSMutableDictionary dictionary];
                for (int i = 0; i < 5; i++)
                    [states setObject:[TicketMetaData descriptionForState:i]
                        forKey:[NSNumber numberWithInt:i]];
                self.itemSelectionTableViewController.selectedItem =
                    [NSNumber numberWithInt:state];
                [self.itemSelectionTableViewController
                    setItems:states];
                [self.navigationController
                    pushViewController:self.itemSelectionTableViewController
                    animated:YES];
                break;
        }
    }
}

#pragma mark UITableViewDelegate implementation

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark EditTicketViewController implementation

- (IBAction)cancel:(id)sender
{
    if (descriptionTextField.editing)
        [descriptionTextField resignFirstResponder];
    else if (tagsTextField.editing)
        [tagsTextField resignFirstResponder];
    else
        [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)update:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

+ (UITableViewCell *)createCellForSection:(NSUInteger)section
{
    UITableViewCell * cell;

    if (section == kEditTicketActionSection)
        cell =
            [[[HOTableViewCell alloc]
            initWithFrame:CGRectZero reuseIdentifier:@"HOTableViewCell"
            tableViewStyle:UITableViewStyleGrouped]
            autorelease];
    else {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"EditTicketTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    return cell;
}

- (UITableViewCell *)dequeueCellForSection:(NSUInteger)section
{
    NSString * cellIdentifier =
        section == kEditTicketActionSection ?
        @"HOTableViewCell" : @"EditTicketTableViewCell";
    
    return [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
}

#pragma mark UITextFieldDelegate implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    updateButton.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    updateButton.enabled = YES;

    self.ticketDescription = descriptionTextField.text;
    self.tags = tagsTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark Accessors

- (AddCommentViewController *)addCommentViewController
{
    if (!addCommentViewController)
        addCommentViewController =
            [[AddCommentViewController alloc]
            initWithNibName:@"AddCommentView" bundle:nil];

    return addCommentViewController;
}

- (ItemSelectionTableViewController *)itemSelectionTableViewController
{
    if (!itemSelectionTableViewController)
        itemSelectionTableViewController =
            [[ItemSelectionTableViewController alloc]
            initWithNibName:@"ItemSelectionTableView" bundle:nil];

    return itemSelectionTableViewController;
}

@end
