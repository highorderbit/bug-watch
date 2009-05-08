//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestonesTableViewCell.h"
#import "RoundedRectView.h"
#import "MilestoneProgressView.h"
#import "Milestone.h"
#import "NSDate+StringHelpers.h"
#import "UIColor+BugWatchColors.h"

@interface MilestonesTableViewCell ()

- (void)setSelectedColors;
- (void)setNonSelectedColors;

@end

@implementation MilestonesTableViewCell

@synthesize milestone;

- (void)dealloc
{
    [nameLabel release];
    [dueDateLabel release];

    [numOpenTicketsView release];
    [numOpenTicketsLabel release];
    [numOpenTicketsTitleLabel release];
    [numOpenTicketsViewBackgroundColor release];

    [progressView release];

    [milestone release];

    [super dealloc];
}

- (void)awakeFromNib
{
    // cache the num tickets view's background color set in the nib
    numOpenTicketsViewBackgroundColor =
        [numOpenTicketsView.backgroundColor retain];
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
        [NSString stringWithFormat:@"%@", milestone.numOpenTickets];
    numOpenTicketsTitleLabel.text =
        [milestone.numOpenTickets integerValue] == 1 ?
        NSLocalizedString(@"milestones.tickets.open.count.label.singular",
        @"") :
        NSLocalizedString(@"milestones.tickets.open.count.label.plural", @"");

    if (milestone.numTickets == 0)
        progressView.progress = 0.0;
    else
        progressView.progress =
            ((float) [milestone.numTickets integerValue] -
                     [milestone.numOpenTickets integerValue]) /
            (float) [milestone.numTickets integerValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected)
        [self setSelectedColors];
    else
        [self setNonSelectedColors];
}

#pragma mark Setting selection colors

- (void)setSelectedColors
{
    nameLabel.textColor = [UIColor whiteColor];
    dueDateLabel.textColor = [UIColor whiteColor];

    numOpenTicketsView.backgroundColor = [UIColor whiteColor];
    numOpenTicketsLabel.textColor =
        [UIColor selectedTableViewCellBackgroundColor];
    numOpenTicketsTitleLabel.textColor =
        [UIColor selectedTableViewCellBackgroundColor];

    progressView.outlineColor = [UIColor whiteColor];
    progressView.progressColor = [UIColor selectedTableViewCellBackgroundColor];
}

- (void)setNonSelectedColors
{
    nameLabel.textColor = [UIColor blackColor];

    numOpenTicketsView.backgroundColor = numOpenTicketsViewBackgroundColor;
    numOpenTicketsLabel.textColor = [UIColor whiteColor];
    numOpenTicketsTitleLabel.textColor = [UIColor whiteColor];

    progressView.outlineColor = [UIColor blackColor];

    BOOL late =
        milestone.dueDate &&
        [milestone.dueDate compare:[NSDate date]] == NSOrderedAscending;
    if (late) {
        dueDateLabel.textColor = [UIColor lateMilestoneProgressColor];
        progressView.progressColor = [UIColor lateMilestoneProgressColor];
    } else {
        dueDateLabel.textColor = [UIColor bugWatchBlueColor];
        progressView.progressColor = [UIColor milestoneProgressColor];
    }
}

@end
