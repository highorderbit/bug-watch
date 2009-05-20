//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UIColor+BugWatchColors.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface MessageTableViewCell (Private)

- (void)setNonSelectedTextColors;

@end

@implementation MessageTableViewCell

- (void)dealloc
{
    [authorLabel release];
    [dateLabel release];
    [projectLabel release];
    [titleLabel release];
    [commentLabel release];
    [numResponsesLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    UIImage * backgroundImage =
        [UIImage imageNamed:@"TableViewCellGradient.png"];
    self.backgroundView =
        [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    self.backgroundView.contentMode = UIViewContentModeBottom;
    
    [self setNonSelectedTextColors];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        authorLabel.textColor = [UIColor whiteColor];
        dateLabel.textColor = [UIColor whiteColor];
        projectLabel.textColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor whiteColor];
        commentLabel.textColor = [UIColor whiteColor];
        numResponsesLabel.textColor = [UIColor whiteColor];
    } else
        [self setNonSelectedTextColors];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat titleHeight = [titleLabel heightForString:titleLabel.text];
    CGRect titleLabelFrame = titleLabel.frame;
    titleLabelFrame.size.height = titleHeight;
    titleLabel.frame = titleLabelFrame;

    CGFloat commentHeight = [commentLabel heightForString:commentLabel.text];
    static const CGFloat MAX_COMMENT_HEIGHT = 54;
    commentHeight =
        commentHeight > MAX_COMMENT_HEIGHT ? MAX_COMMENT_HEIGHT : commentHeight;
    CGRect commentLabelFrame = commentLabel.frame;
    commentLabelFrame.size.height = commentHeight;
    commentLabelFrame.origin.y = titleHeight + 52;
    commentLabel.frame = commentLabelFrame;
}

- (void)setNonSelectedTextColors
{
    authorLabel.textColor = [UIColor blackColor];
    dateLabel.textColor = [UIColor bugWatchBlueColor];
    projectLabel.textColor = [UIColor bugWatchGrayColor];
    titleLabel.textColor = [UIColor blackColor];
    commentLabel.textColor = [UIColor blackColor];
    numResponsesLabel.textColor = [UIColor bugWatchGrayColor];
}

- (void)setAuthorName:(NSString *)authorName
{
    authorLabel.text = authorName;
}

- (void)setDate:(NSDate *)date
{
    dateLabel.text = [date shortDescription];
}

- (void)setProjectName:(NSString *)projectName
{
    projectLabel.text = projectName;
}

- (void)setTitleText:(NSString *)text
{
    titleLabel.text = text;
}

- (void)setCommentText:(NSString *)text
{
    commentLabel.text = text;
}

- (void)setNumResponses:(NSUInteger)numResponses
{   
    NSString * formatString =
        numResponses == 1 ? @"%d comment" : @"%d comments";
    numResponsesLabel.text =
        [NSString stringWithFormat:formatString, numResponses];
}

+  (CGFloat)heightForTitle:(NSString   *)title  comment:(NSString   *)comment  {
UILineBreakMode            mode            =            UILineBreakModeWordWrap;

 CGSize titleMaxSize  = CGSizeMake(288, 999999.0); UIFont *  titleFont = [UIFont
boldSystemFontOfSize:14.0];  CGSize  titleSize =  [title  sizeWithFont:titleFont
constrainedToSize:titleMaxSize                              lineBreakMode:mode];

    CGSize commentMaxSize = CGSizeMake(288, 54.0);
    UIFont * commentFont = [UIFont systemFontOfSize:14.0];
    CGSize commentSize =
        [comment sizeWithFont:commentFont constrainedToSize:commentMaxSize
        lineBreakMode:mode];

    static const NSUInteger MIN_HEIGHT = 0;
    NSUInteger height = 60.0 + commentSize.height + titleSize.height;
    height = height > MIN_HEIGHT ? height : MIN_HEIGHT;

    return height;
}

@end
