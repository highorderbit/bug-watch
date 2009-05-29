//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketTableViewCell.h"
#import "Ticket.h"
#import "TicketMetaData.h"
#import "NSDate+StringHelpers.h"
#import "UIColor+BugWatchColors.h"
#import "UILabel+DrawingAdditions.h"

@interface TicketTableViewCell (Private)

- (void)setNonSelectedTextColors;

@end

@implementation TicketTableViewCell

- (void)dealloc
{
    [numberLabel release];
    [stateLabel release];
    [lastUpdatedLabel release];
    [descriptionLabel release];
    [assignedToLabel release];
    [milestoneLabel release];
    [stateLabelColor release];
    [resolveButton release];

    [super dealloc];
}

- (void)awakeFromNib
{
    UIImage * backgroundImage =
        [UIImage imageNamed:@"TableViewCellGradient.png"];
    self.backgroundView =
        [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    self.backgroundView.contentMode =  UIViewContentModeBottom;
    resolveButton.titleShadowOffset = CGSizeMake(-1.0, -1.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        numberLabel.textColor = [UIColor whiteColor];
        stateLabel.textColor = [UIColor whiteColor];
        lastUpdatedLabel.textColor = [UIColor whiteColor];
        descriptionLabel.textColor = [UIColor whiteColor];
        assignedToLabel.textColor = [UIColor whiteColor];
        milestoneLabel.textColor = [UIColor whiteColor];
    } else
        [self setNonSelectedTextColors];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat descriptionHeight =
        [descriptionLabel heightForString:descriptionLabel.text];
    CGRect descriptionLabelFrame = descriptionLabel.frame;
    descriptionLabelFrame.size.height = descriptionHeight;
    descriptionLabel.frame = descriptionLabelFrame;
    
    const static CGFloat MIN_BASE_LABEL_Y = 18;
    CGFloat baseLabelY =
        descriptionHeight > MIN_BASE_LABEL_Y ?
        descriptionHeight : MIN_BASE_LABEL_Y;
    
    CGRect assignedToLabelFrame = assignedToLabel.frame;
    assignedToLabelFrame.origin.y = baseLabelY + 12;
    assignedToLabel.frame = assignedToLabelFrame;
    
    CGRect lastUpdatedLabelFrame = lastUpdatedLabel.frame;
    lastUpdatedLabelFrame.origin.y = baseLabelY + 11;
    lastUpdatedLabel.frame = lastUpdatedLabelFrame;
    
    CGRect milestoneLabelFrame = milestoneLabel.frame;
    milestoneLabelFrame.origin.y = baseLabelY + 29;
    milestoneLabel.frame = milestoneLabelFrame;
    
    CGRect stateLabelFrame = stateLabel.frame;
    stateLabelFrame.origin.y = baseLabelY + 28;
    stateLabel.frame = stateLabelFrame;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    CGRect resolveButtonFrame = resolveButton.frame;
    static const CGFloat MARGIN = 6;

    if (editing) { // show resolve button
        resolveButtonFrame.origin.x = 320 - MARGIN;
        resolveButtonFrame.origin.y =
            self.frame.size.height / 2 - resolveButtonFrame.size.height / 2;
        resolveButton.frame = resolveButtonFrame;

        [self addSubview:resolveButton];

        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone
                forView:resolveButton cache:YES];
        }

        resolveButtonFrame.origin.x =
            320 - MARGIN - resolveButtonFrame.size.width;
        resolveButton.frame = resolveButtonFrame;
        
        if (animated)
            [UIView commitAnimations];
            
        numberLabel.hidden = YES;
        stateLabel.hidden = YES;
        lastUpdatedLabel.hidden = YES;
    } else {
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone
                forView:resolveButton cache:YES];
        }

        resolveButtonFrame.origin.x = 320 - MARGIN;
        resolveButton.frame = resolveButtonFrame;
        
        if (animated)
            [UIView commitAnimations];
        
        [resolveButton performSelector:@selector(removeFromSuperview)
            withObject:nil afterDelay:0.2];
            
        [numberLabel performSelector:@selector(setHidden:) withObject:nil
            afterDelay:0.2];
        [stateLabel performSelector:@selector(setHidden:) withObject:nil
            afterDelay:0.2];
        [lastUpdatedLabel performSelector:@selector(setHidden:) withObject:nil
            afterDelay:0.2];
    }
}

#pragma mark TicketTableViewCell implementation

- (void)setNumber:(NSUInteger)number
{
    numberLabel.text = [NSString stringWithFormat:@"# %d", number];
}

- (void)setState:(NSUInteger)state
{
    stateLabel.text = [TicketMetaData descriptionForState:state];
    [stateLabelColor release];
    stateLabelColor = [[UIColor bugWatchColorForState:state] retain];
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

- (void)setMilestoneName:(NSString *)milestoneName
{
    milestoneLabel.text =
        [NSString stringWithFormat:@"Milestone: %@", milestoneName];
}

+ (CGFloat)heightForContent:(NSString *)description
{
    CGSize maxSize = CGSizeMake(234, 999999.0);
    UIFont * font = [UIFont boldSystemFontOfSize:14.0];
    UILineBreakMode mode = UILineBreakModeWordWrap;

    CGSize size =
        [description sizeWithFont:font constrainedToSize:maxSize
        lineBreakMode:mode];

    static const NSUInteger MIN_HEIGHT = 73;
    NSUInteger height = 55.0 + size.height;
    height = height > MIN_HEIGHT ? height : MIN_HEIGHT;

    return height;
}

- (void)setNonSelectedTextColors
{
    numberLabel.textColor = [UIColor bugWatchGrayColor];
    stateLabel.textColor = stateLabelColor;
    lastUpdatedLabel.textColor = [UIColor bugWatchBlueColor];
    descriptionLabel.textColor = [UIColor blackColor];
    assignedToLabel.textColor = [UIColor bugWatchGrayColor];
    milestoneLabel.textColor = [UIColor bugWatchGrayColor];
}

@end
