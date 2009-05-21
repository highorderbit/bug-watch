//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "EditTicketTableViewCell.h"
#import "UIColor+BugWatchColors.h"
#import "UILabel+DrawingAdditions.h"

@interface EditTicketTableViewCell (Private)

- (void)setNonSelectedTextColors;

@end

@implementation EditTicketTableViewCell

@synthesize keyOnly;

- (void)dealloc
{
    [keyLabel release];
    [valueLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [self setNonSelectedTextColors];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        keyLabel.textColor = [UIColor whiteColor];
        valueLabel.textColor = [UIColor whiteColor];
    } else
        [self setNonSelectedTextColors];
}

- (void)setKeyText:(NSString *)text
{
    keyLabel.text = text;
}

- (void)setValueText:(NSString *)text
{
    valueLabel.text = text;
}

- (void)setNonSelectedTextColors
{
    keyLabel.textColor = [UIColor bugWatchLabelColor];
    valueLabel.textColor = [UIColor blackColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat MAX_HEIGHT = 42;
    CGFloat valueHeight =
        [valueLabel heightForString:valueLabel.text];
    valueHeight = valueHeight > MAX_HEIGHT ? MAX_HEIGHT : valueHeight;
    CGRect valueLabelFrame = valueLabel.frame;
    valueLabelFrame.size.height = valueHeight;
    
    CGRect keyLabelFrame = keyLabel.frame;
    if (!keyOnly) {
        valueLabelFrame.size.width = 172;
        keyLabelFrame.size.width = 80;
        keyLabel.textAlignment = UITextAlignmentRight;
    } else {
        valueLabelFrame.size.width = 0;
        keyLabelFrame.size.width = 266;
        keyLabel.textAlignment = UITextAlignmentLeft;
    }
    
    valueLabel.frame = valueLabelFrame;
    keyLabel.frame = keyLabelFrame;
}

+ (CGFloat)heightForContent:(NSString *)content
{
    CGSize maxSize = CGSizeMake(172, 36.0);
    UIFont * font = [UIFont boldSystemFontOfSize:16.0];
    UILineBreakMode mode = UILineBreakModeWordWrap;

    CGSize size =
        [content sizeWithFont:font constrainedToSize:maxSize
        lineBreakMode:mode];

    static const NSUInteger MIN_HEIGHT = 44;
    NSUInteger height = 26.0 + size.height;
    height = height > MIN_HEIGHT ? height : MIN_HEIGHT;

    return height;
}

@end
