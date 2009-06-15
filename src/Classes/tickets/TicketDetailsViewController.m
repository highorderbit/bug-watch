//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDetailsViewController.h"
#import "UIColor+BugWatchColors.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"
#import "CommentTableViewCell.h"
#import "TicketComment.h"

@interface TicketDetailsViewController (Private)

- (void)layoutView;
- (NSArray *)sortedKeys;

@end

@implementation TicketDetailsViewController

@synthesize delegate, ticket, milestoneName, reportedByName, assignedToName;

- (void)dealloc {
    [headerView release];
    [footerView release];
    [metaDataView release];
    [gradientImage release];
    [numberLabel release];
    [stateLabel release];
    [dateLabel release];
    [descriptionLabel release];
    [reportedByLabel release];
    [assignedToLabel release];
    [milestoneLabel release];
    [messageLabel release];

    [comments release];
    [commentAuthors release];
    [ticket release];
    [milestoneName release];
    [reportedByName release];
    [assignedToName release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[comments allKeys] count] - 1; // don't show first element
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    return [[comments allKeys] count] > 1 ? @"Comments and changes" : nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"CommentTableViewCell";
    
    CommentTableViewCell * cell =
        (CommentTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    id commentKey = [[self sortedKeys] objectAtIndex:indexPath.row + 1];
    TicketComment * comment = [comments objectForKey:commentKey];
    [cell setDate:comment.date];
    [cell setStateChangeText:comment.stateChangeDescription];
    [cell setCommentText:comment.text];

    NSString * authorName = [commentAuthors objectForKey:commentKey];
    [cell setAuthorName:authorName];

    return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id commentKey = [[self sortedKeys] objectAtIndex:indexPath.row + 1];
    TicketComment * comment = [comments objectForKey:commentKey];

    return [CommentTableViewCell heightForContent:comment.text
        stateChangeText:comment.stateChangeDescription];
}

#pragma mark UITableViewDelegate implementation

- (NSIndexPath *)tableView:(UITableView *)tableView
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark TicketDetailsViewController implementation

- (void)setTicketNumber:(NSUInteger)aNumber
    ticket:(Ticket *)aTicket metaData:(TicketMetaData *)someMetaData
    reportedBy:(NSString *)reportedBy assignedTo:(NSString *)assignedTo
    milestone:(NSString *)milestone comments:(NSDictionary * )someComments
    commentAuthors:(NSDictionary *)someCommentAuthors
{
    ticketNumber = aNumber;
    self.ticket = aTicket;
    self.milestoneName = milestone;
    self.reportedByName = reportedBy;
    self.assignedToName = assignedTo;

    self.navigationItem.title =
        [NSString stringWithFormat:@"Ticket %d", aNumber];
    numberLabel.text = [NSString stringWithFormat:@"# %d", aNumber];
    stateLabel.text = [TicketMetaData descriptionForState:someMetaData.state];
    stateLabel.textColor = [UIColor bugWatchColorForState:someMetaData.state];
    dateLabel.text = [aTicket.creationDate shortDescription];
    descriptionLabel.text = aTicket.description;
    NSString * reportedByText = reportedBy ? reportedBy : @"none";
    reportedByLabel.text =
        [NSString stringWithFormat:@"Reported by: %@", reportedByText];
    NSString * assignedToText = assignedTo ? assignedTo : @"none";
    assignedToLabel.text =
        [NSString stringWithFormat:@"Assigned to: %@", assignedToText];
    NSString * milestoneText = milestone ? milestone : @"none";
    milestoneLabel.text =
        [NSString stringWithFormat:@"Milestone: %@", milestoneText];

    NSDictionary * tempComments = [someComments copy];
    [comments release];
    comments = tempComments;

    TicketComment * firstComment =
        [comments objectForKey:[[self sortedKeys] objectAtIndex:0]];
    messageLabel.text = firstComment.text;

    NSDictionary * tempCommentAuthors = [someCommentAuthors copy];
    [commentAuthors release];
    commentAuthors = tempCommentAuthors;

    [self layoutView];
    [self.tableView reloadData];
    NSLog(@"Updated details view with state %@",
        [TicketMetaData descriptionForState:someMetaData.state]);
}

- (void)layoutView
{
    CGFloat descriptionHeight =
        [descriptionLabel heightForString:descriptionLabel.text];
    CGRect descriptionLabelFrame = descriptionLabel.frame;
    descriptionLabelFrame.size.height = descriptionHeight;
    descriptionLabel.frame = descriptionLabelFrame;
    
    const static CGFloat MIN_BASE_LABEL_Y = 0;
    const static CGFloat LABEL_OFFSET = 19;
    CGFloat baseLabelY = 300 +
        (descriptionHeight > MIN_BASE_LABEL_Y ?
        descriptionHeight : MIN_BASE_LABEL_Y);

    CGRect reportedByLabelFrame = reportedByLabel.frame;
    reportedByLabelFrame.origin.y = baseLabelY + 14;
    reportedByLabel.frame = reportedByLabelFrame;
    
    CGRect assignedToLabelFrame = assignedToLabel.frame;
    assignedToLabelFrame.origin.y =
        reportedByLabelFrame.origin.y + LABEL_OFFSET;
    assignedToLabel.frame = assignedToLabelFrame;

    CGRect milestoneLabelFrame = milestoneLabel.frame;
    milestoneLabelFrame.origin.y = assignedToLabelFrame.origin.y + LABEL_OFFSET;
    milestoneLabel.frame = milestoneLabelFrame;

    CGRect dateLabelFrame = dateLabel.frame;
    dateLabelFrame.origin.y = reportedByLabelFrame.origin.y;
    dateLabel.frame = dateLabelFrame;
    
    CGRect stateLabelFrame = stateLabel.frame;
    stateLabelFrame.origin.y = assignedToLabelFrame.origin.y - 1;
    stateLabel.frame = stateLabelFrame;
    
    CGRect metaDataViewFrame = metaDataView.frame;
    metaDataViewFrame.size.height = milestoneLabelFrame.origin.y + 30;
    metaDataView.frame = metaDataViewFrame;
    
    CGRect gradientImageFrame = gradientImage.frame;
    gradientImageFrame.origin.y =
        metaDataViewFrame.size.height - gradientImageFrame.size.height;
    gradientImage.frame = gradientImageFrame;
    
    const static CGFloat COMMENT_PADDING = 10;
    
    CGRect messageLabelFrame = messageLabel.frame;
    messageLabelFrame.origin.y =
        metaDataViewFrame.size.height + COMMENT_PADDING;
    messageLabel.frame = messageLabelFrame;

    CGFloat messageHeight =
        [messageLabel heightForString:messageLabel.text];
    messageLabelFrame.size.height = messageHeight;
    messageLabel.frame = messageLabelFrame;

    CGRect headerViewFrame = headerView.frame;
    NSInteger headerViewOffset =
        ![messageLabel.text isEqual:@""] ?
        COMMENT_PADDING : -1 * COMMENT_PADDING;
    headerViewFrame.size.height =
        messageLabelFrame.origin.y + messageLabelFrame.size.height +
        headerViewOffset;
    headerView.frame = headerViewFrame;

    // necessary to reset header height allocation for table view
    self.tableView.tableHeaderView = headerView;
}

- (NSArray *)sortedKeys
{
    return [[comments allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark Action button implementation

- (IBAction)sendInEmail:(id)sender
{
    NSLog(@"Sending ticket details email...");

    NSString * subject =
        [NSString stringWithFormat:@"Lighthouse Ticket #%d: %@", ticketNumber,
        self.ticket.description];
    NSMutableString * body = [NSMutableString stringWithCapacity:0];
    [body appendFormat:@"\nDetails:\n"];
    [body appendFormat:@"\nTicket #%d: %@\n", ticketNumber,
        self.ticket.description];
    TicketComment * firstComment =
        [comments objectForKey:[[self sortedKeys] objectAtIndex:0]];
    if (firstComment.text)
        [body appendFormat:@"\n%@\n", firstComment.text];
    if (self.milestoneName)
        [body appendFormat:@"\nMilestone: %@", self.milestoneName];
    [body appendFormat:@"\nReported by: %@", self.reportedByName];
    if (self.assignedToName)
        [body appendFormat:@"\nAssigned to: %@", self.assignedToName];
    [body appendFormat:@"\nCreated: %@",
        [self.ticket.creationDate shortDateAndTimeDescription]];

    NSString * urlString =
        [[NSString stringWithFormat:@"mailto:?subject=%@&body=%@", subject,
        body]
        stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL * url = [[NSURL alloc] initWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

- (IBAction)openInBrowser:(id)sender
{
    NSLog(@"Opening ticket details in browser...");

    NSString * webAddress = self.ticket.link;
    NSURL * url = [[NSURL alloc] initWithString:webAddress];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

@end
