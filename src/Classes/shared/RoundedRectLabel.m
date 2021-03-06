//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "RoundedRectLabel.h"

@implementation RoundedRectLabel

@synthesize roundedRectColor;
@synthesize highlightedRoundedRectColor;
@synthesize roundedCornerWidth;
@synthesize roundedCornerHeight;

- (void)dealloc
{
    [label release];
    [roundedRectColor release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.roundedRectColor =
        [UIColor colorWithRed:.549 green:.6 blue:.706 alpha:1];
    self.highlightedRoundedRectColor = [UIColor whiteColor];

    roundedCornerWidth = 20;
    roundedCornerHeight = self.frame.size.height;

    // configure label
    CGRect labelFrame =
        CGRectMake(0, -1, self.frame.size.width, self.frame.size.height);
    label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.numberOfLines = 1;
    label.highlightedTextColor =
        [UIColor colorWithRed:0.008 green:0.427 blue:0.925 alpha:1.0];
    label.text = @"23";
    [self addSubview:label];
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark UIView implementation

- (void)setFrame:(CGRect)aFrame
{
    [super setFrame:aFrame];
    
    CGRect labelFrame =
        CGRectMake(0, -1, self.frame.size.width, self.frame.size.height);
    label.frame = labelFrame;
}

- (void)sizeToFit
{
    [label sizeToFit];
    CGRect newFrame = self.frame;
    newFrame.size.width = label.frame.size.width + 18;
    self.frame = newFrame;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextClearRect(context, rect);
    UIColor * rectColor =
        self.highlighted ?
        self.highlightedRoundedRectColor : self.roundedRectColor;

    CGContextSetFillColorWithColor(context, [rectColor CGColor]);

    CGContextFillRect(context,
        CGRectMake(roundedCornerWidth / 2, 0,
        self.frame.size.width - roundedCornerWidth, self.frame.size.height));
    
    // Draw rounded corners
    CGContextFillEllipseInRect(context,
        CGRectMake(0, 0, roundedCornerWidth, roundedCornerHeight));
    CGContextFillEllipseInRect(context,
        CGRectMake(0, self.frame.size.height - roundedCornerHeight,
        roundedCornerWidth, roundedCornerHeight));
    CGContextFillRect(context,
        CGRectMake(0, roundedCornerHeight / 2, roundedCornerWidth,
        self.frame.size.height - roundedCornerHeight));

    CGContextFillEllipseInRect(context,
        CGRectMake(self.frame.size.width - roundedCornerWidth, 0,
        roundedCornerWidth, roundedCornerHeight));
    CGContextFillEllipseInRect(context,
        CGRectMake(self.frame.size.width - roundedCornerWidth,
        self.frame.size.height - roundedCornerHeight, roundedCornerWidth,
        roundedCornerHeight));
    CGContextFillRect(context,
        CGRectMake(self.frame.size.width - roundedCornerWidth,
        roundedCornerHeight / 2, roundedCornerWidth,
        self.frame.size.height - roundedCornerHeight));
}

#pragma mark Accessors

- (void)setText:(NSString *)text
{
    label.text = text;
}

- (NSString *)text
{
    return label.text;
}

- (void)setFont:(UIFont *)font
{
    label.font = font;
}

- (UIFont *)font
{
    return label.font;
}

- (void)setRoundedRectColor:(UIColor *)aRoundedRectColor
{
    [aRoundedRectColor retain];
    [roundedRectColor release];
    roundedRectColor = aRoundedRectColor;
    
    [self setNeedsDisplay];
}

- (void)setHighlightedRoundedRectColor:(UIColor *)aRoundedRectColor
{
    [aRoundedRectColor retain];
    [highlightedRoundedRectColor release];
    highlightedRoundedRectColor = aRoundedRectColor;
    
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)aHighlightedVal
{
    [super setHighlighted:aHighlightedVal];
    [self setNeedsDisplay];
}

@end
