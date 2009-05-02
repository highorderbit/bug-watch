//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "EditTicketTableViewCell.h"

@implementation EditTicketTableViewCell

- (void)dealloc
{
    [keyLabel release];
    [valueLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setKeyText:(NSString *)text
{
    keyLabel.text = text;
}

- (void)setValueText:(NSString *)text
{
    valueLabel.text = text;
}

@end
