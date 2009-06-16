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
    kEditTicketTitleSection,
    kEditTicketStateSection,
    kEditTicketTagsSection
};

enum EditTicketCell
{
    kTitle,
    kComment,
    kAssignedTo,
    kMilestone,
    kState,
    kTags
};

@interface EditTicketViewController (Private)

+ (NSString *)unsetText;
- (NSDictionary *)milestonesPlusNone;
- (NSDictionary *)membersPlusNone;
- (NSDictionary *)statesPlusNone;
- (NSInteger)rowForIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numRowsForSection:(NSInteger)section;
- (NSString *)valueForRow:(NSInteger)row;
- (void)setStateWithNumber:(NSNumber *)aState;

@end

static const NSInteger UNSET_KEY = 0;

@implementation EditTicketViewController

@synthesize cancelButton, updateButton;
@synthesize ticketDescription, comment, tags;
@synthesize members, member;
@synthesize milestones, milestone;
@synthesize state;
@synthesize edit;
@synthesize target, action, deleteTicketAction;

- (void)dealloc
{
    [cancelButton release];
    [updateButton release];
    [footerView release];
    [deleteButton release];

    [addCommentViewController release];
    [itemSelectionTableViewController release];

    [ticketDescription release];
    [comment release];
    [tags release];
    
    [members release];
    [member release];

    [milestones release];
    [milestone release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor bugWatchBackgroundColor];
    self.tableView.tableFooterView = footerView;
    deleteButton.titleShadowOffset = CGSizeMake(-0.5, -0.5);

    [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    [self.navigationItem setRightBarButtonItem:updateButton animated:NO];
    self.edit = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
    updateButton.enabled =
        ticketDescription && ![ticketDescription isEqual:@""];
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [self numRowsForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"EditTicketTableViewCell";
    
    EditTicketTableViewCell * cell =
        (EditTicketTableViewCell *)
        [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"EditTicketTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }

    NSInteger row = [self rowForIndexPath:indexPath];
    NSString * valueForRow = [self valueForRow:row];
    [cell setValueText:valueForRow];

    NSString * titleLabel = NSLocalizedString(@"editticket.label.title", @"");
    NSString * commentLabel =
        NSLocalizedString(@"editticket.label.comment", @"");
    NSString * addACommentLabel =
        NSLocalizedString(@"editticket.label.addacomment", @"");
    NSString * descriptionLabel =
        NSLocalizedString(@"editticket.label.description", @"");
    NSString * assignedToLabel =
        NSLocalizedString(@"editticket.label.assignedto", @"");
    NSString * milestoneLabel =
        NSLocalizedString(@"editticket.label.milestone", @"");
    NSString * stateLabel = NSLocalizedString(@"editticket.label.state", @"");
    NSString * tagsLabel = NSLocalizedString(@"editticket.label.tags", @"");

    switch(row) {
        case kTitle:
            [cell setKeyText:titleLabel];
            break;
        case kComment:
            if (edit) {
                if (self.comment && ![self.comment isEqual:@""]) {
                    [cell setKeyText:commentLabel];
                    cell.keyOnly = NO;
                } else {
                    [cell setKeyText:addACommentLabel];
                    cell.keyOnly = YES;
                }
            } else {
                [cell setKeyText:descriptionLabel];
                cell.keyOnly = NO;
            }
            break;
        case kAssignedTo:
            [cell setKeyText:assignedToLabel];
            break;
        case kMilestone:
            [cell setKeyText:milestoneLabel];
            break;
        case kState:
            [cell setKeyText:stateLabel];
            break;
        case kTags:
            [cell setKeyText:tagsLabel];
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [self rowForIndexPath:indexPath];
    switch (row) {
        case kTitle:
            self.addCommentViewController.navigationItem.title =
                NSLocalizedString(@"editticket.editing.title", @"");
            self.addCommentViewController.autocorrectionType =
                UITextAutocorrectionTypeDefault;
            [self.navigationController
                pushViewController:self.addCommentViewController
                animated:YES];
            self.addCommentViewController.action =
                @selector(setTicketDescription:);
            [self.addCommentViewController
                setTextViewText:self.ticketDescription];
            break;
        case kComment:
            self.addCommentViewController.navigationItem.title =
                NSLocalizedString(@"editticket.editing.comment", @"");
            self.addCommentViewController.autocorrectionType =
                UITextAutocorrectionTypeDefault;
            [self.navigationController
                pushViewController:self.addCommentViewController
                animated:YES];
            self.addCommentViewController.action = @selector(setComment:);
            [self.addCommentViewController setTextViewText:self.comment];
            break;
        case kAssignedTo:
            self.itemSelectionTableViewController.navigationItem.title =
                NSLocalizedString(@"editticket.editing.assignedto", @"");
            [self.itemSelectionTableViewController
                setItems:self.membersPlusNone];
            self.itemSelectionTableViewController.selectedItem =
                self.member;
            self.itemSelectionTableViewController.action =
                @selector(setMember:);
            [self.navigationController
                pushViewController:self.itemSelectionTableViewController
                animated:YES];
            break;
        case kMilestone:
            self.itemSelectionTableViewController.navigationItem.title =
                NSLocalizedString(@"editticket.editing.milestone", @"");
            [self.itemSelectionTableViewController
                setItems:self.milestonesPlusNone];
            self.itemSelectionTableViewController.selectedItem =
                self.milestone;
            self.itemSelectionTableViewController.action =
                @selector(setMilestone:);
            [self.navigationController
                pushViewController:self.itemSelectionTableViewController
                animated:YES];
            break;
        case kState:
            self.itemSelectionTableViewController.navigationItem.title =
                NSLocalizedString(@"editticket.editing.state", @"");
            [self.itemSelectionTableViewController
                setItems:self.statesPlusNone];
            self.itemSelectionTableViewController.selectedItem =
                [NSNumber numberWithInt:state];
            self.itemSelectionTableViewController.action =
                @selector(setStateWithNumber:);
            [self.navigationController
                pushViewController:self.itemSelectionTableViewController
                animated:YES];
            break;
        case kTags:
            self.addCommentViewController.navigationItem.title =
                NSLocalizedString(@"editticket.editing.tags", @"");
            self.addCommentViewController.autocorrectionType =
                UITextAutocorrectionTypeNo;
            [self.navigationController
                pushViewController:self.addCommentViewController
                animated:YES];
            self.addCommentViewController.action = @selector(setTags:);
            [self.addCommentViewController setTextViewText:self.tags];
            break;
    }
}

#pragma mark UITableViewDelegate implementation

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView
    accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [self rowForIndexPath:indexPath];
    NSString * valueForRow = [self valueForRow:row];

    return [EditTicketTableViewCell heightForContent:valueForRow];
}

#pragma mark Table view helpers

- (NSInteger)rowForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numRows = indexPath.row;
    for (int i = kEditTicketTitleSection; i < indexPath.section; i++)
        numRows += [self numRowsForSection:i];

    return numRows;
}

- (NSInteger)numRowsForSection:(NSInteger)section
{
    NSInteger numRows;
    switch(section) {
        case kEditTicketTitleSection:
            numRows = 2;
            break;
        case kEditTicketStateSection:
            numRows = 3;
            break;
        case kEditTicketTagsSection:
            numRows = 1;
            break;
    }

    return numRows;
}

- (NSString *)valueForRow:(NSInteger)row
{
    NSString * value;
    switch(row) {
        case kTitle:
            value = self.ticketDescription;
            break;
        case kComment:
            value = self.comment;
            break;
        case kAssignedTo:
            value = [self.membersPlusNone objectForKey:self.member];
            break;
        case kMilestone:
            value = [self.milestonesPlusNone objectForKey:self.milestone];
            break;
        case kState:
            value =
                state >= kNew ?
                [TicketMetaData descriptionForState:state] :
                [[self class] unsetText];
            break;
        case kTags:
            value = self.tags;
            break;
    }
    value = value && ![value isEqual:@""] ? value : @"--";

    return value;
}

#pragma mark EditTicketViewController implementation

- (IBAction)cancel:(id)sender
{
    if ([self.navigationController.viewControllers count] == 1)
        [self dismissModalViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)update:(id)sender
{
    NSMethodSignature * sig =
        [[target class] instanceMethodSignatureForSelector:action];
    NSInvocation * invocation =
        [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:target];
    [invocation setSelector:action];
    [invocation setArgument:&self atIndex:2];
    [invocation retainArguments];
    [invocation invoke];
}

- (IBAction)deleteTicket:(id)sender
{
    NSLog(@"Delete ticket button tapped.");
    NSString * confirmText =
        NSLocalizedString(@"editticket.delete.confirm", @"");
    NSString * cancelText = NSLocalizedString(@"editticket.delete.cancel", @"");
    UIActionSheet * actionSheet =
        [[UIActionSheet alloc]
        initWithTitle:nil delegate:self cancelButtonTitle:cancelText
        destructiveButtonTitle:confirmText otherButtonTitles:nil, nil];

	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
        [target performSelector:deleteTicketAction withObject:nil];
}

#pragma mark Accessors

+ (NSString *)unsetText
{
    return NSLocalizedString(@"editticket.unset", @"");
}

- (AddCommentViewController *)addCommentViewController
{
    if (!addCommentViewController) {
        addCommentViewController =
            [[AddCommentViewController alloc]
            initWithNibName:@"AddCommentView" bundle:nil];
        addCommentViewController.target = self;
    }

    return addCommentViewController;
}

- (ItemSelectionTableViewController *)itemSelectionTableViewController
{
    if (!itemSelectionTableViewController) {
        itemSelectionTableViewController =
            [[ItemSelectionTableViewController alloc]
            initWithNibName:@"ItemSelectionTableView" bundle:nil];
        itemSelectionTableViewController.target = self;
    }

    return itemSelectionTableViewController;
}

- (void)setEdit:(BOOL)editVal
{
    edit = editVal;
    NSString * editTitle = NSLocalizedString(@"editticket.edittitle", @"");
    NSString * addTitle = NSLocalizedString(@"editticket.addtitle", @"");
    self.navigationItem.title = edit ? editTitle : addTitle;
    self.tableView.tableFooterView = edit ? footerView : nil;
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

- (void)setTicketDescription:(NSString *)aTicketDescription
{
    NSLog(@"Set ticket title: '%@'", aTicketDescription);

    NSString * tempTicketDescription = [aTicketDescription copy];
    [ticketDescription release];
    ticketDescription = tempTicketDescription;

    updateButton.enabled =
        aTicketDescription && ![aTicketDescription isEqual:@""];

    [self.tableView reloadData];
}

- (void)setComment:(NSString *)aComment
{
    NSLog(@"Set ticket comment: '%@'", aComment);

    NSString * tempComment = [aComment copy];
    [comment release];
    comment = tempComment;

    [self.tableView reloadData];
}

- (void)setTags:(NSString *)someTags
{
    NSLog(@"Set ticket tags: '%@'", someTags);

    NSString * tempTags = [someTags copy];
    [tags release];
    tags = tempTags;

    [self.tableView reloadData];
}

- (void)setMember:(id)aMember
{
    NSLog(@"Set ticket owner: '%@'", aMember);

    id tempMember = [aMember copy];
    [member release];
    member = tempMember;

    [self.tableView reloadData];
}

- (void)setMilestone:(id)aMilestone
{
    NSLog(@"Set ticket milestone: '%@'", aMilestone);

    id tempMilestone = [aMilestone copy];
    [milestone release];
    milestone = tempMilestone;

    [self.tableView reloadData];
}

- (void)setStateWithNumber:(NSNumber *)aState
{
    self.state = [aState intValue];
}

- (void)setState:(NSUInteger)aState
{
    NSLog(@"Set ticket state: '%d'", aState);
    state = aState;
    [self.tableView reloadData];
}

@end
