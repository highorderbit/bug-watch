//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketTableViewCell.h"
#import "Ticket.h"
#import "NSDate+StringHelpers.h"
#import "UIColor+BugWatchColors.h"
#import "UILabel+DrawingAdditions.h"

@implementation TicketTableViewCell

- (void)dealloc
{
    [numberLabel release];
    [stateLabel release];
    [lastUpdatedLabel release];
    [descriptionLabel release];
    [assignedToLabel release];
    [stateLabelColor release];

    [super dealloc];
}

- (void)awakeFromNib
{
    UIImage * backgroundImage =
        [UIImage imageNamed:@"TableViewCellGradient.png"];
    self.backgroundView =
        [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat descriptionHeight =
        [descriptionLabel heightForString:descriptionLabel.text];
    CGRect descriptionLabelFrame = descriptionLabel.frame;
    descriptionLabelFrame.size.height = descriptionHeight;
    descriptionLabel.frame = descriptionLabelFrame;
    
    CGRect assignedToLabelFrame = assignedToLabel.frame;
    assignedToLabelFrame.origin.y = descriptionHeight + 6;
    assignedToLabel.frame = assignedToLabelFrame;
}

#pragma mark TicketTableViewCell implementation

- (void)setNumber:(NSUInteger)number
{
    numberLabel.text = [NSString stringWithFormat:@"# %d", number];
}

- (void)setState:(NSUInteger)state
{
    stateLabel.text = [Ticket descriptionForState:state];
    stateLabelColor = [UIColor bugWatchColorForState:state];
    stateLabel.textColor = stateLabelColor;
}

- (void)setLastUpdatedDate:(NSDate *)lastUpdatedDate
{
    lastUpdatedLabel.text = [lastUpdatedDate shortDescription];
}

- (void)setDescription:(NSString *)description
{
    descriptionLabel.text = description;
}

- (void)setAssignedToName:(NSString *)assignedToName
{
    assignedToLabel.text =
        [NSString stringWithFormat:@"Assigned to: %@", assignedToName];
}

+ (CGFloat)heightForContent:(NSString *)description
{
    CGSize maxSize = CGSizeMake(207, 999999.0);
    UIFont * font = [UIFont systemFontOfSize:14.0];
    UILineBreakMode mode = UILineBreakModeWordWrap;

    CGSize size =
        [description sizeWithFont:font constrainedToSize:maxSize
        lineBreakMode:mode];

    static const NSUInteger MIN_HEIGHT = 78;
    NSUInteger height = 32.0 + size.height;
    height = height > MIN_HEIGHT ? height : MIN_HEIGHT;

    return height;
}

@end
