//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TextWithCountTableViewCell.h"

@implementation TextWithCountTableViewCell

- (void)dealloc
{
    [titleLabel release];
    [countLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    titleLabel.highlightedTextColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [countLabel sizeToFit];
    
    NSInteger padding =
        self.accessoryType == UITableViewCellAccessoryNone ? 15 : 8;
    CGRect countFrame = countLabel.frame;
    countFrame.origin.x =
        self.contentView.frame.size.width - countFrame.size.width - padding;
    countLabel.frame = countFrame;
    
    CGRect textFrame = titleLabel.frame;
    textFrame.size.width =
        self.contentView.frame.size.width - textFrame.origin.x -
        countFrame.size.width - 20;
    titleLabel.frame = textFrame;
}

- (void)setText:(NSString *)text
{
    titleLabel.text = text;
}

- (void)setCount:(NSUInteger)count
{
    countLabel.text = [NSString stringWithFormat:@"%d", count];
}

@end
