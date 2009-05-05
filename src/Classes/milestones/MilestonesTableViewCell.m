//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestonesTableViewCell.h"
#import "Milestone.h"
#import "NSDate+StringHelpers.h"

@implementation MilestonesTableViewCell

@synthesize milestone;

- (void)dealloc
{
    [nameLabel release];
    [dueDateLabel release];
    [numOpenTicketsLabel release];
    [numOpenTicketsTitleLabel release];
    [progressView release];

    [milestone release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    nameLabel.text = milestone.name;
    if (milestone.dueDate)
        dueDateLabel.text =
            [NSString stringWithFormat:
            NSLocalizedString(@"milestones.due.future.formatstring", @""),
            [milestone.dueDate shortDateDescription]];
    else
        dueDateLabel.text =
            NSLocalizedString(@"milestones.due.never.formatstring", @"");

    numOpenTicketsLabel.text =
        [NSString stringWithFormat:@"%d", milestone.numOpenTickets];
    numOpenTicketsTitleLabel.text =
        milestone.numOpenTickets == 1 ?
        NSLocalizedString(@"milestones.tickets.open.count.label.singular",
        @"") :
        NSLocalizedString(@"milestones.tickets.open.count.label.plural", @"");

    if (milestone.numTickets == 0)
        progressView.progress = 0.0;
    else
        progressView.progress =
            ((float) milestone.numTickets - milestone.numOpenTickets) /
            (float) milestone.numTickets;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
