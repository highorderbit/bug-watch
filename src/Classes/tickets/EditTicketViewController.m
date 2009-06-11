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
    kEditTicketCommentSection,
    kEditTicketStateSection,
    kEditTicketTagsSection
};

enum EditTicketCell
{
    kTitle,
    kDescription,
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
@synthesize ticketDescription, message, comment, tags;
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
    [message release];
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
    return 4;
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

    switch(row) {
        case kTitle:
            [cell setKeyText:@"title"];
            break;
        case kDescription:
            [cell setKeyText:@"description"];
            break;
        case kComment:
            if (self.comment && ![self.comment isEqual:@""]) {
                [cell setKeyText:@"comment"];
                cell.keyOnly = NO;
            } else {
                [cell setKeyText:@"add a comment"];
                cell.keyOnly = YES;
            }
            break;
        case kAssignedTo:
            [cell setKeyText:@"assigned to"];
            break;
        case kMilestone:
            [cell setKeyText:@"milestone"];
            break;
        case kState:
            [cell setKeyText:@"state"];
            break;
        case kTags:
            [cell setKeyText:@"tags"];
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
                @"Edit Title";
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
                @"Add Comment";
            self.addCommentViewController.autocorrectionType =
                UITextAutocorrectionTypeDefault;
            [self.navigationController
                pushViewController:self.addCommentViewController
                animated:YES];
            self.addCommentViewController.action = @selector(setComment:);
            [self.addCommentViewController setTextViewText:self.comment];
            break;
        case kDescription:
            self.addCommentViewController.navigationItem.title =
                @"Edit Description";
            self.addCommentViewController.autocorrectionType =
                UITextAutocorrectionTypeDefault;
            [self.navigationController
                pushViewController:self.addCommentViewController
                animated:YES];
            self.addCommentViewController.action = @selector(setMessage:);
            [self.addCommentViewController setTextViewText:self.message];
            break;
        case kAssignedTo:
            self.itemSelectionTableViewController.navigationItem.title =
                @"Set Owner";
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
                @"Set Milestone";
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
                @"Set State";
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
                @"Edit Tags";
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

    if (!edit && indexPath.section >= kEditTicketCommentSection)
        numRows++;

    return numRows;
}

- (NSInteger)numRowsForSection:(NSInteger)section
{
    NSInteger numRows;
    switch(section) {
        case kEditTicketTitleSection:
            numRows = 2;
            break;
        case kEditTicketCommentSection:
            numRows = self.edit ? 1 : 0;
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
        case kDescription:
            value = self.message;
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

    UIActionSheet * actionSheet =
        [[UIActionSheet alloc]
        initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:@"Delete Ticket" otherButtonTitles:nil, nil];

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
    return @"-- none --";
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
    self.navigationItem.title = edit ? @"Edit Ticket" : @"Add Ticket";
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

- (void)setMessage:(NSString *)aMessage
{
    NSLog(@"Set ticket description: '%@'", aMessage);

    NSString * tempMessage = [aMessage copy];
    [message release];
    message = tempMessage;
    
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
