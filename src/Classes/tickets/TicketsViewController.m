//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketsViewController.h"
#import "Ticket.h"
#import "TicketTableViewCell.h"

@interface TicketsViewController (Private)

- (void)updateNavigationBarForNotSearching:(BOOL)animated;

@end

@implementation TicketsViewController

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [searchTextField release];
    [cancelButton release];
    [addButton release];
    [super dealloc];
}

#pragma mark UIViewController implementation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Can't be set in IB, so setting it here
    CGRect frame = searchTextField.frame;
    frame.size.height = 28;
    searchTextField.frame = frame;
    
    searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // TEMPORARY
    NSMutableDictionary * tempTickets = [NSMutableDictionary dictionary];
    
    NSString * description1 = @"If timing is just right, updating view can be added to wrong view controller when backing out of drill-down";
    Ticket * ticket1 =
        [[Ticket alloc] initWithDescription:description1
        state:(NSUInteger)kNew creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    NSString * description2 = @"Add disclosure indicators to news feed";
    Ticket * ticket2 =
        [[Ticket alloc] initWithDescription:description2
        state:(NSUInteger)kResolved creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    NSString * description3 = @"Support followed users in GitHub service";
    Ticket * ticket3 =
        [[Ticket alloc] initWithDescription:description3
        state:(NSUInteger)kHold creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    NSString * description4 = @"Keypad 'done' button incorrectly enabled on log in and favorites";
    Ticket * ticket4 =
        [[Ticket alloc] initWithDescription:description4
        state:(NSUInteger)kResolved creationDate:[NSDate date]
        lastModifiedDate:[NSDate date] comments:nil];

    [tempTickets setObject:ticket1 forKey:[NSNumber numberWithInt:213]];
    [tempTickets setObject:ticket2 forKey:[NSNumber numberWithInt:56]];
    [tempTickets setObject:ticket3 forKey:[NSNumber numberWithInt:217]];
    [tempTickets setObject:ticket4 forKey:[NSNumber numberWithInt:4]];
    
    self.tickets = tempTickets;
    // TEMPORARY
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateNavigationBarForNotSearching:animated];
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView
    numberOfRowsInSection:(NSInteger)section
{
    return [tickets count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TicketTableViewCell";
    
    TicketTableViewCell * cell =
        (TicketTableViewCell *)
        [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"TicketTableViewCell"
                owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }
    
    NSNumber * ticketNumber = [[tickets allKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketNumber];
    [cell setNumber:[ticketNumber intValue]];
    [cell setState:ticket.state];
    [cell setDescription:ticket.description];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark UITableViewDelegate implementation

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber * ticketNumber = [[tickets allKeys] objectAtIndex:indexPath.row];
    Ticket * ticket = [tickets objectForKey:ticketNumber];
    
    return [TicketTableViewCell heightForContent:ticket.description];
}

#pragma mark UITextFieldDelegate implementation

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone
        forView:searchTextField cache:YES];

    CGRect frame = searchTextField.frame;
    frame.size.width = 245;
    searchTextField.frame = frame;

    [UIView commitAnimations];

    [self.navigationItem setRightBarButtonItem:cancelButton animated:YES];
}

#pragma mark TicketsViewController implementation

- (void)setTickets:(NSDictionary *)someTickets
{
    NSDictionary * tempTickets = [someTickets copy];
    [tickets release];
    tickets = tempTickets;
    
    [self.tableView reloadData];
}

- (NSDictionary *)tickets
{
    return [tickets copy];
}

- (IBAction)cancelSelected:(id)sender
{
    [searchTextField resignFirstResponder];
    [self updateNavigationBarForNotSearching:YES];
}

- (IBAction)addSelected:(id)sender
{}

- (void)updateNavigationBarForNotSearching:(BOOL)animated
{
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone
            forView:searchTextField cache:YES];
    }

    CGRect frame = searchTextField.frame;
    frame.size.width = 270;
    searchTextField.frame = frame;
    
    if (animated)
        [UIView commitAnimations];
    
    [self.navigationItem setRightBarButtonItem:addButton animated:animated];
}

@end

