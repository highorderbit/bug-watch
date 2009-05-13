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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // 
    // if (selected)
    //     textLabel.textColor = [UIColor whiteColor];
    // else
    //     textLabel.textColor = [UIColor blackColor];
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
