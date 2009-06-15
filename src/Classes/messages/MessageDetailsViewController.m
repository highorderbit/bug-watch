//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDetailsViewController.h"
#import "UILabel+DrawingAdditions.h"
#import "ResponseTableViewCell.h"
#import "NSDate+StringHelpers.h"
#import "MessageResponse.h"

@interface MessageDetailsViewController (Private)

- (void)layoutView;

@end

@implementation MessageDetailsViewController

@synthesize authorName, date, title, comment, link;

- (void)dealloc
{
    [headerView release];
    [footerView release];
    [metaDataView release];
    [gradientImage release];

    [authorLabel release];
    [dateLabel release];
    [projectLabel release];
    [titleLabel release];
    [commentLabel release];

    [responses release];
    [responseAuthors release];
    [title release];
    [comment release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
    self.navigationItem.title = @"Message Info";
}

#pragma mark UITableViewDelegate implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section
{
    return [[responses allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
    cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"ResponseTableViewCell";
    
    ResponseTableViewCell * cell =
        (ResponseTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        NSArray * nib =
            [[NSBundle mainBundle] loadNibNamed:@"ResponseTableViewCell"
            owner:self options:nil];

        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    id responseKey = [[responses allKeys] objectAtIndex:indexPath.row];
    MessageResponse * response = [responses objectForKey:responseKey];
    NSString * author = [responseAuthors objectForKey:responseKey];
    [cell setDate:response.date];
    [cell setCommentText:response.text];
    [cell setAuthorName:author];

    return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section
{
    NSString * responsesSectionHeader =
        NSLocalizedString(@"messagedetails.view.responsesheading", @"");

    return [[responses allKeys] count] > 0 ? responsesSectionHeader : nil;
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id responseKey = [[responses allKeys] objectAtIndex:indexPath.row];
    MessageResponse * response = [responses objectForKey:responseKey];
    NSString * aComment = response.text;

    return [ResponseTableViewCell heightForContent:aComment];
}

- (NSIndexPath *)tableView:(UITableView *)tableView
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark MessageDetailsViewController implementation

- (void)setAuthorName:(NSString *)anAuthorName date:(NSDate *)aDate
    projectName:(NSString *)projectName title:(NSString *)aTitle
    comment:(NSString *)aComment responses:(NSDictionary *)someResponses
    responseAuthors:(NSDictionary *)someResponseAuthors link:(NSString *)aLink
{
    self.authorName = anAuthorName;
    self.date = aDate;
    self.title = aTitle;
    self.comment = aComment;
    self.link = aLink;

    authorLabel.text = authorName;
    dateLabel.text = [date shortDescription];
    projectLabel.text = projectName;
    titleLabel.text = title;
    commentLabel.text = comment;

    [someResponses retain];
    [responses release];
    responses = someResponses;

    [someResponseAuthors retain];
    [responseAuthors release];
    responseAuthors = someResponseAuthors;

    [self layoutView];
    [self.tableView reloadData];
}

- (void)layoutView
{
    CGFloat titleHeight =
        [titleLabel heightForString:titleLabel.text];
    CGRect titleLabelFrame = titleLabel.frame;
    titleLabelFrame.size.height = titleHeight;
    titleLabel.frame = titleLabelFrame;
    
    const static CGFloat MIN_BASE_LABEL_Y = 0;
    CGFloat baseLabelY = 300 +
        (titleHeight > MIN_BASE_LABEL_Y ?
        titleHeight : MIN_BASE_LABEL_Y);
        
    CGRect metaDataViewFrame = metaDataView.frame;
    metaDataViewFrame.size.height = baseLabelY + 60;
    metaDataView.frame = metaDataViewFrame;

    CGRect gradientImageFrame = gradientImage.frame;
    gradientImageFrame.origin.y =
        metaDataViewFrame.size.height - gradientImageFrame.size.height;
    gradientImage.frame = gradientImageFrame;

    const static CGFloat COMMENT_PADDING = 10;

    CGRect commentLabelFrame = commentLabel.frame;
    commentLabelFrame.origin.y =
        metaDataViewFrame.size.height + COMMENT_PADDING;
    commentLabel.frame = commentLabelFrame;

    CGFloat commentHeight =
        [commentLabel heightForString:commentLabel.text];
    commentLabelFrame.size.height = commentHeight;
    commentLabel.frame = commentLabelFrame;

    CGRect headerViewFrame = headerView.frame;
    NSInteger headerViewOffset =
        commentLabel.text != @"" ? COMMENT_PADDING : -1 * COMMENT_PADDING;
    headerViewFrame.size.height =
        commentLabelFrame.origin.y + commentLabelFrame.size.height +
        headerViewOffset;
    headerView.frame = headerViewFrame;

    // necessary to reset header height allocation for table view
    self.tableView.tableHeaderView = headerView;
}

#pragma mark Action button implementation

- (IBAction)sendInEmail:(id)sender
{
    NSLog(@"Sending message details email...");

    NSString * subjectFormatString =
        NSLocalizedString(@"messagedetails.view.email.subject", @"");
    NSString * subject =
        [NSString stringWithFormat:subjectFormatString, self.title];
    NSMutableString * body = [NSMutableString stringWithCapacity:0];
    NSString * detailsString =
        NSLocalizedString(@"messagedetails.view.email.details", @"");
    [body appendFormat:detailsString];
    [body appendFormat:@"\n%@", self.title];
    if (self.comment)
        [body appendFormat:@"\n%@", self.comment];
    NSString * postedByFormatString =
        NSLocalizedString(@"messagedetails.view.email.postedby", @"");
    [body appendFormat:postedByFormatString, self.authorName,
        [self.date shortDateAndTimeDescription]];

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
    NSLog(@"Opening message details in browser...");

    NSString * webAddress = self.link;
    NSURL * url = [[NSURL alloc] initWithString:webAddress];
    [[UIApplication sharedApplication] openURL:url];
    [url release];
}

@end
