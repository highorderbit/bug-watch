//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneHeaderView.h"
#import "Milestone.h"
#import "MilestoneProgressView.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"

@interface MilestoneHeaderView ()

- (void)updateDisplay;

@end

@implementation MilestoneHeaderView

@synthesize milestone;

- (void)dealloc
{
    [nameLabel release];
    [dueDateLabel release];
    [goalsLabel release];

    [numOpenTicketsView release];
    [numOpenTicketsLabel release];
    [numOpenTicketsTitleLabel release];
    [numOpenTicketsViewBackgroundColor release];

    [progressView release];

    [milestone release];

    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self updateDisplay];
}

- (void)updateDisplay
{
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
        [NSString stringWithFormat:@"%u", milestone.numOpenTickets];
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

    goalsLabel.text = milestone.goals;
    CGFloat amountToGrow = [goalsLabel sizeVerticallyToFit];

    CGRect frame = self.frame;
    frame.size.height = frame.size.height + amountToGrow;
    self.frame = frame;
}

#pragma mark Accessors

- (void)setMilestone:(Milestone *)aMilestone
{
    Milestone * tmp = [aMilestone copy];
    [milestone release];
    milestone = tmp;

    [self setNeedsLayout];
}

@end
