//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectHomeTableViewCell.h"

@interface ProjectHomeTableViewCell (Private)

- (void)setIcon;

@end

@implementation ProjectHomeTableViewCell

- (void)dealloc {
    [label release];
    [iconView release];
    [icon release];
    [highlightedIcon release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [label setHighlightedTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setIcon];
}

- (void)setLabelText:(NSString *)text
{
    label.text = text;
}

- (void)setImage:(UIImage *)anIcon
{
    [anIcon retain];
    [icon release];
    icon = anIcon;

    [self setIcon];
}

- (void)setHighlightedImage:(UIImage *)aHighlightedIcon
{
    [aHighlightedIcon retain];
    [highlightedIcon release];
    highlightedIcon = aHighlightedIcon;

    [self setIcon];
}

- (void)setIcon
{
    iconView.image = self.selected ? highlightedIcon : icon;
    iconView.alpha = self.selected ? 1.0 : 0.8;
}

@end
