//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDetailsViewController.h"
#import "UIColor+BugWatchColors.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"
#import "CommentTableViewCell.h"
#import "TicketComment.h"
#import "TicketDiffHelpers.h"

@interface TicketDetailsViewController (Private)

- (void)layoutView;
- (NSArray *)sortedKeys;
- (NSString *)stateChangeDescriptionForCommentNumber:(NSUInteger)index;

@end

@implementation TicketDetailsViewController

@synthesize delegate, ticket, metadata, milestoneKey, reportedByKey,
    assignedToKey, userNames, milestoneNames;

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
    [milestoneKey release];
    [reportedByKey release];
    [assignedToKey release];

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
    NSString * commentsAndChangesHeading =
        NSLocalizedString(@"ticketdetails.view.commentsandchangesheading", @"");

    return [[comments allKeys] count] > 1 ? commentsAndChangesHeading : nil;
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

    NSUInteger commentIndex = indexPath.row + 1;
    id commentKey = [[self sortedKeys] objectAtIndex:commentIndex];
    TicketComment * comment = [comments objectForKey:commentKey];
    [cell setDate:comment.date];
    
    NSString * stateChangeDescription =
        [self stateChangeDescriptionForCommentNumber:commentIndex];
    [cell setStateChangeText:stateChangeDescription];

    [cell setCommentText:comment.text];

    NSString * authorName = [commentAuthors objectForKey:commentKey];
    // in case author dictionary is incomplete or not set
    authorName = authorName ? authorName : @"...";
    [cell setAuthorName:authorName];

    return cell;
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger commentIndex = indexPath.row + 1;
    id commentKey = [[self sortedKeys] objectAtIndex:commentIndex];
    TicketComment * comment = [comments objectForKey:commentKey];

    NSString * stateChangeDescription =
        [self stateChangeDescriptionForCommentNumber:commentIndex];

    return [CommentTableViewCell heightForContent:comment.text
        stateChangeText:stateChangeDescription];
}

- (NSString *)stateChangeDescriptionForCommentNumber:(NSUInteger)index
{
    NSMutableArray * diffs = [NSMutableArray array];
    NSArray * commentKeys = [self sortedKeys];
    for (id key in commentKeys) {
        TicketComment * comment = [comments objectForKey:key];
        [diffs addObject:comment.stateChange];
    }
    NSMutableDictionary * currentStateDiff = [NSMutableDictionary dictionary];
    [currentStateDiff
        setObject:[TicketMetaData descriptionForState:self.metadata.state]
        forKey:[NSNumber numberWithInt:kTicketAttributeState]];
    [currentStateDiff setObject:self.assignedToKey
        forKey:[NSNumber numberWithInt:kTicketAttributeAssignedTo]];
    [currentStateDiff setObject:self.milestoneKey
        forKey:[NSNumber numberWithInt:kTicketAttributeMilestone]];
    [currentStateDiff setObject:self.metadata.tags
        forKey:[NSNumber numberWithInt:kTicketAttributeTags]];
    [diffs addObject:currentStateDiff];

    return [TicketDiffHelpers descriptionFromDiffs:diffs atIndex:index
        withUserNames:self.userNames milestoneNames:self.milestoneNames];
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
    reportedByKey:(NSNumber *)aReportedByKey
    assignedToKey:(NSNumber *)anAssignedToKey
    milestoneKey:(LighthouseKey *)aMilestoneKey
    comments:(NSDictionary * )someComments
    commentAuthors:(NSDictionary *)someCommentAuthors
    userNames:(NSDictionary *)someUserNames
    milestoneNames:(NSDictionary *)someMilestoneNames
{
    if (!aTicket)
        [NSException raise:@"NilTicketArgument"
            format:@"'ticket' cannot be nil"];
    if (!someMetaData)
        [NSException raise:@"NilMetadataArgument"
            format:@"'metadata' cannot be nil"];
    if (!aReportedByKey)
        [NSException raise:@"NilReportedByArgument"
            format:@"'reportedBy' cannot be nil"];
    if (!someComments)
        [NSException raise:@"NilCommentsArgument"
            format:@"'comments' cannot be nil"];

    ticketNumber = aNumber;
    self.ticket = aTicket;
    self.metadata = someMetaData;
    self.milestoneKey = aMilestoneKey;
    self.reportedByKey = aReportedByKey;
    self.assignedToKey = anAssignedToKey;

    NSString * viewTitleFormatString =
        NSLocalizedString(@"ticketdetails.view.title", @"");
    self.navigationItem.title =
        [NSString stringWithFormat:viewTitleFormatString, aNumber];
    numberLabel.text = [NSString stringWithFormat:@"# %d", aNumber];
    stateLabel.text = [TicketMetaData descriptionForState:someMetaData.state];
    stateLabel.textColor = [UIColor bugWatchColorForState:someMetaData.state];
    dateLabel.text = [aTicket.creationDate shortDescription];
    NSString * noneString = NSLocalizedString(@"ticketdetails.view.none", @"");
    descriptionLabel.text = aTicket.description;
    NSString * reportedBy = [someUserNames objectForKey:reportedByKey];
    NSString * reportedByFormatString =
        NSLocalizedString(@"ticketdetails.view.reportedby", @"");
    reportedByLabel.text =
        [NSString stringWithFormat:reportedByFormatString, reportedBy];
    NSString * assignedTo = [someUserNames objectForKey:assignedToKey];
    NSString * assignedToText = assignedTo ? assignedTo : noneString;
    NSString * assignedToFormatString =
        NSLocalizedString(@"ticketdetails.view.assignedto", @"");
    assignedToLabel.text =
        [NSString stringWithFormat:assignedToFormatString, assignedToText];
    NSString * milestone = [someMilestoneNames objectForKey:milestoneKey];
    NSString * milestoneText = milestone ? milestone : noneString;
    NSString * milestoneFormatString =
        NSLocalizedString(@"ticketdetails.view.milestone", @"");
    milestoneLabel.text =
        [NSString stringWithFormat:milestoneFormatString, milestoneText];

    NSDictionary * tempComments = [someComments copy];
    [comments release];
    comments = tempComments;

    TicketComment * firstComment =
        [comments objectForKey:[[self sortedKeys] objectAtIndex:0]];
    messageLabel.text = firstComment.text;

    NSDictionary * tempCommentAuthors = [someCommentAuthors copy];
    [commentAuthors release];
    commentAuthors = tempCommentAuthors;

    self.userNames = someUserNames;
    self.milestoneNames = someMilestoneNames;

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
    
    NSString * subjectFormatString =
        NSLocalizedString(@"ticketdetails.view.email.subject", @"");
    NSString * detailsString =
        NSLocalizedString(@"ticketdetails.view.email.details", @"");
    NSString * titleFormatString =
        NSLocalizedString(@"ticketdetails.view.email.title", @"");
    NSString * descriptionFormatString =
        NSLocalizedString(@"ticketdetails.view.email.description", @"");
    NSString * milestoneFormatString =
        NSLocalizedString(@"ticketdetails.view.email.milestone", @"");
    NSString * reportedByFormatString =
        NSLocalizedString(@"ticketdetails.view.email.reportedby", @"");
    NSString * assignedToFormatString =
        NSLocalizedString(@"ticketdetails.view.email.assignedTo", @"");
    NSString * createdFormatString =
        NSLocalizedString(@"ticketdetails.view.email.created", @"");

    NSString * subject =
        [NSString stringWithFormat:subjectFormatString, ticketNumber,
        self.ticket.description];
    NSMutableString * body = [NSMutableString stringWithCapacity:0];
    [body appendFormat:detailsString];
    [body appendFormat:titleFormatString, ticketNumber,
        self.ticket.description];
    TicketComment * firstComment =
        [comments objectForKey:[[self sortedKeys] objectAtIndex:0]];
    if (firstComment.text)
        [body appendFormat:descriptionFormatString, firstComment.text];
    NSString * milestoneName =
        [self.milestoneNames objectForKey:self.milestoneKey];
    if (milestoneName)
        [body appendFormat:milestoneFormatString, milestoneName];
    NSString * reportedByName = [userNames objectForKey:self.reportedByKey];
    [body appendFormat:reportedByFormatString, reportedByName];
    NSString * assignedToName = [userNames objectForKey:self.assignedToKey];
    if (assignedToName)
        [body appendFormat:assignedToFormatString, assignedToName];
    [body appendFormat:createdFormatString,
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
