//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RoundedRectView.h"

@interface RoundedRectView ()

- (void)setBackgroundColor:(UIColor *)color;
- (UIColor *)backgroundColor;

@end

@implementation RoundedRectView

@synthesize roundedCornerSize;

- (void)dealloc
{
    [fillColor release];
    [super dealloc];
}

- (void)initialize
{
    roundedCornerSize = CGSizeMake(5.0, 5.0);
    [self setBackgroundColor:self.backgroundColor];
    super.backgroundColor = [UIColor clearColor];
}

- (void)awakeFromNib
{
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self initialize];

    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextClearRect(context, rect);

    const CGFloat * rgb = CGColorGetComponents(self.backgroundColor.CGColor);
    CGContextSetRGBFillColor(context, rgb[0], rgb[1], rgb[2], rgb[3]);

    CGContextFillRect(context,
        CGRectMake(roundedCornerSize.width / 2,
        0,
        self.frame.size.width - roundedCornerSize.width,
        self.frame.size.height));

    CGContextFillEllipseInRect(context,
        CGRectMake(
        0,
        0,
        roundedCornerSize.width,
        roundedCornerSize.height));
    CGContextFillEllipseInRect(context,
        CGRectMake(
        0,
        self.frame.size.height - roundedCornerSize.height,
        roundedCornerSize.width,
        roundedCornerSize.height));
    CGContextFillRect(context,
        CGRectMake(
        0,
        roundedCornerSize.height / 2,
        roundedCornerSize.width,
        self.frame.size.height - roundedCornerSize.height));

    CGContextFillEllipseInRect(context,
        CGRectMake(
        self.frame.size.width - roundedCornerSize.width,
        0,
        roundedCornerSize.width,
        roundedCornerSize.height));
    CGContextFillEllipseInRect(context,
        CGRectMake(
        self.frame.size.width - roundedCornerSize.width,
        self.frame.size.height - roundedCornerSize.height,
        roundedCornerSize.width,
        roundedCornerSize.height));
    CGContextFillRect(context,
        CGRectMake(
        self.frame.size.width - roundedCornerSize.width,
        roundedCornerSize.height / 2,
        roundedCornerSize.width,
        self.frame.size.height - roundedCornerSize.height));
}

#pragma mark Accessors

- (void)setBackgroundColor:(UIColor *)color
{
    UIColor * tmp = [color retain];
    [fillColor release];
    fillColor = tmp;
}

- (UIColor *)backgroundColor
{
    return fillColor;
}

@end
