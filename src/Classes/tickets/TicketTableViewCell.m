//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketTableViewCell.h"
#import "Ticket.h"
#import "NSDate+StringHelpers.h"
#import "UIColor+BugWatchColors.h"

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

    // Configure the view for the selected state
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

@end
