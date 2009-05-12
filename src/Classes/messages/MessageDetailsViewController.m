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

- (void)dealloc
{
    [headerView release];
    [metaDataView release];
    [gradientImage release];

    [authorLabel release];
    [dateLabel release];
    [projectLabel release];
    [titleLabel release];
    [commentLabel release];

    [responses release];
    [responseAuthors release];

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableHeaderView = headerView;
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
    static NSString * cellIdentifier = @"Cell";
    
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
    return [[responses allKeys] count] > 0 ? @"Responses" : nil;
}

- (CGFloat)tableView:(UITableView *)aTableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id responseKey = [[responses allKeys] objectAtIndex:indexPath.row];
    MessageResponse * response = [responses objectForKey:responseKey];
    NSString * comment = response.text;

    return [ResponseTableViewCell heightForContent:comment];
}

- (NSIndexPath *)tableView:(UITableView *)tableView
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark MessageDetailsViewController implementation

- (void)setAuthorName:(NSString *)authorName date:(NSDate *)date
    projectName:(NSString *)projectName title:(NSString *)title
    comment:(NSString *)comment responses:(NSDictionary *)someResponses
    responseAuthors:(NSDictionary *)someResponseAuthors
{
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
    metaDataViewFrame.size.height = baseLabelY + 68;
    metaDataView.frame = metaDataViewFrame;

    CGRect gradientImageFrame = gradientImage.frame;
    gradientImageFrame.origin.y =
        metaDataViewFrame.size.height - gradientImageFrame.size.height;
    gradientImage.frame = gradientImageFrame;

    CGRect commentLabelFrame = commentLabel.frame;
    commentLabelFrame.origin.y = metaDataViewFrame.size.height + 12;
    commentLabel.frame = commentLabelFrame;

    CGFloat commentHeight =
        [commentLabel heightForString:commentLabel.text];
    commentLabelFrame.size.height = commentHeight;
    commentLabel.frame = commentLabelFrame;

    CGRect headerViewFrame = headerView.frame;
    NSInteger headerViewOffset = commentLabel.text != @"" ? 12 : -12;
    headerViewFrame.size.height =
        commentLabelFrame.origin.y + commentLabelFrame.size.height +
        headerViewOffset;
    headerView.frame = headerViewFrame;

    // necessary to reset header height allocation for table view
    self.tableView.tableHeaderView = headerView;
}

@end
