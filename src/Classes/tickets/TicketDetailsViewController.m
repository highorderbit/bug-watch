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

@end

@implementation TicketDetailsViewController

@synthesize delegate;

- (void)dealloc {
    [headerView release];
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
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setRightBarButtonItem:self.editButtonItem
        animated:NO];

    self.tableView.tableHeaderView = headerView;
}

#pragma mark UITableViewController implementation

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // customized editing, don't call super
    [delegate editTicket];
}

#pragma mark UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[comments allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    return [[comments allKeys] count] > 0 ? @"Comments and changes" : nil;
}

// Customize the appearance of table view cells.
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
    }

    id commentKey = [[comments allKeys] objectAtIndex:indexPath.row];
    TicketComment * comment = [comments objectForKey:commentKey];
    [cell setDate:comment.date];
    [cell setStateChangeText:comment.stateChangeDescription];
    [cell setCommentText:comment.text];
    
    NSString * authorName = [commentAuthors objectForKey:commentKey];
    [cell setAuthorName:authorName];

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id commentKey = [[comments allKeys] objectAtIndex:indexPath.row];
    TicketComment * comment = [comments objectForKey:commentKey];

    return [CommentTableViewCell heightForContent:comment.text];
}

- (void)setTicketNumber:(NSUInteger)aNumber
    ticket:(Ticket *)aTicket metaData:(TicketMetaData *)someMetaData
    reportedBy:(NSString *)reportedBy assignedTo:(NSString *)assignedTo
    milestone:(NSString *)milestone comments:(NSDictionary * )someComments
    commentAuthors:(NSDictionary *)someCommentAuthors
{
    self.navigationItem.title =
        [NSString stringWithFormat:@"Ticket %d", aNumber];
    numberLabel.text = [NSString stringWithFormat:@"# %d", aNumber];
    stateLabel.text = [TicketMetaData descriptionForState:someMetaData.state];
    stateLabel.textColor = [UIColor bugWatchColorForState:someMetaData.state];
    dateLabel.text = [aTicket.creationDate shortDescription];
    descriptionLabel.text = aTicket.description;
    messageLabel.text = aTicket.message;
    reportedByLabel.text =
        [NSString stringWithFormat:@"Reported by: %@", reportedBy];
    assignedToLabel.text =
        [NSString stringWithFormat:@"Assigned to: %@", assignedTo];
    milestoneLabel.text =
        [NSString stringWithFormat:@"Milestone: %@", milestone];

    NSDictionary * tempComments = [someComments copy];
    [comments release];
    comments = tempComments;
    
    NSDictionary * tempCommentAuthors = [someCommentAuthors copy];
    [commentAuthors release];
    commentAuthors = tempCommentAuthors;

    [self layoutView];
    [self.tableView reloadData];
}

- (void)layoutView
{
    CGFloat descriptionHeight =
        [descriptionLabel heightForString:descriptionLabel.text];
    CGRect descriptionLabelFrame = descriptionLabel.frame;
    descriptionLabelFrame.size.height = descriptionHeight;
    descriptionLabel.frame = descriptionLabelFrame;
    
    const static CGFloat MIN_BASE_LABEL_Y = 0;
    CGFloat baseLabelY = 300 +
        (descriptionHeight > MIN_BASE_LABEL_Y ?
        descriptionHeight : MIN_BASE_LABEL_Y);

    CGRect reportedByLabelFrame = reportedByLabel.frame;
    reportedByLabelFrame.origin.y = baseLabelY + 17;
    reportedByLabel.frame = reportedByLabelFrame;
    
    CGRect assignedToLabelFrame = assignedToLabel.frame;
    assignedToLabelFrame.origin.y = baseLabelY + 36;
    assignedToLabel.frame = assignedToLabelFrame;
    
    CGRect dateLabelFrame = dateLabel.frame;
    dateLabelFrame.origin.y = baseLabelY + 17;
    dateLabel.frame = dateLabelFrame;
    
    CGRect milestoneLabelFrame = milestoneLabel.frame;
    milestoneLabelFrame.origin.y = baseLabelY + 55;
    milestoneLabel.frame = milestoneLabelFrame;
    
    CGRect stateLabelFrame = stateLabel.frame;
    stateLabelFrame.origin.y = baseLabelY + 35;
    stateLabel.frame = stateLabelFrame;
    
    CGRect metaDataViewFrame = metaDataView.frame;
    metaDataViewFrame.size.height = baseLabelY + 86;
    metaDataView.frame = metaDataViewFrame;
    
    CGRect gradientImageFrame = gradientImage.frame;
    gradientImageFrame.origin.y =
        metaDataViewFrame.size.height - gradientImageFrame.size.height;
    gradientImage.frame = gradientImageFrame;
    
    CGRect messageLabelFrame = messageLabel.frame;
    messageLabelFrame.origin.y = metaDataViewFrame.size.height + 12;
    messageLabel.frame = messageLabelFrame;

    CGFloat messageHeight =
        [messageLabel heightForString:messageLabel.text];
    messageLabelFrame.size.height = messageHeight;
    messageLabel.frame = messageLabelFrame;

    CGRect headerViewFrame = headerView.frame;
    NSInteger headerViewOffset = messageLabel.text != @"" ? 12 : -12;
    headerViewFrame.size.height =
        messageLabelFrame.origin.y + messageLabelFrame.size.height +
        headerViewOffset;
    headerView.frame = headerViewFrame;

    // necessary to reset header height allocation for table view
    self.tableView.tableHeaderView = headerView;
}

@end
