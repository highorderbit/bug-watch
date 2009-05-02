//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIColor+BugWatchColors.h"

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
    
    if (selected) {
        authorLabel.textColor = [UIColor whiteColor];
        dateLabel.textColor = [UIColor whiteColor];
        stateChangeLabel.textColor = [UIColor whiteColor];
        commentLabel.textColor = [UIColor whiteColor];
    } else
        [self setNonSelectedTextColors];
}

- (void)setNonSelectedTextColors
{
    authorLabel.textColor = [UIColor blackColor];
    dateLabel.textColor = [UIColor bugWatchBlueColor];
    stateChangeLabel.textColor = [UIColor blackColor];
    commentLabel.textColor = [UIColor blackColor];
}

@end
