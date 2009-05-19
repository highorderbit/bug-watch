//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIColor+BugWatchColors.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface CommentTableViewCell (Private)

- (void)setNonSelectedTextColors;

@end

@implementation CommentTableViewCell

- (void)dealloc
{
    [authorLabel release];
    [dateLabel release];
    [stateChangeLabel release];
    [commentLabel release];
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
    
    if (selected && self.selectionStyle != UITableViewCellSelectionStyleNone) {
        authorLabel.textColor = [UIColor whiteColor];
        dateLabel.textColor = [UIColor whiteColor];
        stateChangeLabel.textColor = [UIColor whiteColor];
        commentLabel.textColor = [UIColor whiteColor];
    } else
        [self setNonSelectedTextColors];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat commentHeight =
        [commentLabel heightForString:commentLabel.text];
    static const CGFloat MAX_COMMENT_HEIGHT = 72;
    commentHeight =
        commentHeight > MAX_COMMENT_HEIGHT ? MAX_COMMENT_HEIGHT : commentHeight;
    CGRect commentLabelFrame = commentLabel.frame;
    commentLabelFrame.size.height = commentHeight;
    commentLabel.frame = commentLabelFrame;
}

- (void)setNonSelectedTextColors
{
    authorLabel.textColor = [UIColor blackColor];
    dateLabel.textColor = [UIColor bugWatchBlueColor];
    stateChangeLabel.textColor = [UIColor blackColor];
    commentLabel.textColor = [UIColor blackColor];
}

- (void)setAuthorName:(NSString *)authorName
{
    authorLabel.text = authorName;
}

- (void)setDate:(NSDate *)date
{
    dateLabel.text = [date shortDescription];
}

- (void)setStateChangeText:(NSString *)text
{
    stateChangeLabel.text = text;
}

- (void)setCommentText:(NSString *)text
{
    commentLabel.text = text;
}

+ (CGFloat)heightForContent:(NSString *)comment
{
    CGSize maxSize = CGSizeMake(302, 72.0);
    UIFont * font = [UIFont systemFontOfSize:14.0];
    UILineBreakMode mode = UILineBreakModeWordWrap;

    CGSize size =
        [comment sizeWithFont:font constrainedToSize:maxSize
        lineBreakMode:mode];

    static const NSUInteger MIN_HEIGHT = 0;
    NSUInteger height = 58.0 + size.height;
    height = height > MIN_HEIGHT ? height : MIN_HEIGHT;

    return height;
}

@end
