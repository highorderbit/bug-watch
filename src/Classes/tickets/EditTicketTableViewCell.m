//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "EditTicketTableViewCell.h"
#import "UIColor+BugWatchColors.h"

@interface EditTicketTableViewCell (Private)

- (void)setNonSelectedTextColors;

@end

@implementation EditTicketTableViewCell

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

@end
