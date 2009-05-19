//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneProgressView.h"
#import "UIColor+BugWatchColors.h"

@implementation MilestoneProgressView

@synthesize outlineColor, progressColor, remainingColor;
@synthesize progress;

- (void)dealloc
{
    [progressView release];
    [remainingView release];

    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    CGRect remainingFrame =
        CGRectMake(
            1.0,
            1.0,
            self.frame.size.width - 2.0,
            self.frame.size.height - 2.0
        );
    remainingView = [[UIView alloc] initWithFrame:remainingFrame];

    CGRect progressFrame = remainingFrame;
    progressFrame.size.width = 0.0;
    progressView = [[UIView alloc] initWithFrame:progressFrame];

    [self addSubview:remainingView];
    [self insertSubview:progressView aboveSubview:remainingView];

    self.outlineColor = [UIColor blackColor];
    self.progressColor = [UIColor milestoneProgressColor];
    self.remainingColor = [UIColor whiteColor];

    self.progress = 0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect frame = progressView.frame;
    frame.size.width = remainingView.frame.size.width * progress;
    progressView.frame = frame;
}

- (void)setOutlineColor:(UIColor *)color
{
    self.backgroundColor = color;
}

- (UIColor *)outlineColor
{
    return self.backgroundColor;
}

- (void)setProgressColor:(UIColor *)color
{
    progressView.backgroundColor = color;
}

- (UIColor *)progressColor
{
    return progressView.backgroundColor;
}

- (void)setRemainingColor:(UIColor *)color
{
    remainingView.backgroundColor = color;
}

- (UIColor *)remainingColor
{
    return remainingView.backgroundColor;
}

- (void)setProgress:(float)f
{
    if (f > 1.0)
        progress = 1.0;
    else if (f < 0.0)
        progress = 0.0;
    else
        progress = f;
}

@end
