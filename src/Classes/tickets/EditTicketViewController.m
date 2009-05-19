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
    kEditDescription,
    kAddComment
};

enum EditTicketCell
{
    kAssignedTo,
    kMilestone,
    kState
};

@interface EditTicketViewController (Private)

+ (UITableViewCell *)createCellForSection:(NSUInteger)section;
+ (NSString *)unsetText;
- (UITableViewCell *)dequeueCellForSection:(NSUInteger)section;
- (NSDictionary *)milestonesPlusNone;
- (NSDictionary *)membersPlusNone;
- (NSDictionary *)statesPlusNone;

@end

static const NSInteger UNSET_KEY = 0;

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

@synthesize edit;

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
    self.edit = YES;
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
    return section == kEditTicketActionSection ? (self.edit ? 2 : 1) : 3;
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
                    [self.membersPlusNone objectForKey:self.member];
                [editTicketCell setValueText:memberName];
                break;
            case kMilestone:
                [editTicketCell setKeyText:@"milestone"];
                NSString * milestoneName =
                    [self.milestonesPlusNone objectForKey:self.milestone];
                [editTicketCell setValueText:milestoneName];
                break;
            case kState:
                [editTicketCell setKeyText:@"state"];
                NSString * descriptionText =
                    state >= kNew ?
                    [TicketMetaData descriptionForState:state] :
                    [[self class] unsetText];
                [editTicketCell
                    setValueText:descriptionText];
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
                [self.itemSelectionTableViewController
                    setItems:self.membersPlusNone];
                self.itemSelectionTableViewController.selectedItem =
                    self.member;
                [self.navigationController
                    pushViewController:self.itemSelectionTableViewController
                    animated:YES];
                break;
            case kMilestone:
                self.itemSelectionTableViewController.navigationItem.title =
                    @"Set Milestone";
                [self.itemSelectionTableViewController
                    setLabelText:@"Milestone"];
                [self.itemSelectionTableViewController
                    setItems:self.milestonesPlusNone];
                self.itemSelectionTableViewController.selectedItem =
                    self.milestone;
                [self.navigationController
                    pushViewController:self.itemSelectionTableViewController
                    animated:YES];
                break;
            case kState:
                self.itemSelectionTableViewController.navigationItem.title =
                    @"Set State";
                [self.itemSelectionTableViewController
                    setLabelText:@"State"];
                [self.itemSelectionTableViewController
                    setItems:self.statesPlusNone];
                self.itemSelectionTableViewController.selectedItem =
                    [NSNumber numberWithInt:state];
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

+ (NSString *)unsetText
{
    return @"-- none --";
}

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

- (void)setEdit:(BOOL)editVal
{
    edit = editVal;
    self.navigationItem.title = edit ? @"Edit Ticket" : @"Add Ticket";
    [self.tableView reloadData];
}

- (NSDictionary *)milestonesPlusNone
{
    NSMutableDictionary * milestonesPlusNone =
        [NSMutableDictionary
        dictionaryWithDictionary:self.milestones];
    [milestonesPlusNone setObject:[[self class] unsetText]
        forKey:[NSNumber numberWithInt:UNSET_KEY]];

    return milestonesPlusNone;
}

- (NSDictionary *)membersPlusNone
{
    NSMutableDictionary * membersPlusNone =
        [NSMutableDictionary dictionaryWithDictionary:self.members];
    [membersPlusNone setObject:[[self class] unsetText]
        forKey:[NSNumber numberWithInt:UNSET_KEY]];

    return membersPlusNone;
}

- (NSDictionary *)statesPlusNone
{
    NSMutableDictionary * states = [NSMutableDictionary dictionary];
    for (int i = kNew; i <= kInvalid; i = i << 1)
        [states setObject:[TicketMetaData descriptionForState:i]
            forKey:[NSNumber numberWithInt:i]];
    [states setObject:[[self class] unsetText]
        forKey:[NSNumber numberWithInt:UNSET_KEY]];

    return states;
}

@end
