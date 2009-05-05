//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RoundedRectView.h"

@implementation RoundedRectView

@synthesize roundedCornerSize;

- (void)dealloc
{
    [fillColor release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // set a reasonable default
    roundedCornerSize = CGSizeMake(7.5, 7.5);

    // save current bg color set in the nib and use for our fill color
    [self setBackgroundColor:self.backgroundColor];
    super.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextClearRect(context, rect);

    CGContextSetFillColorWithColor(context, fillColor.CGColor);

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

    CGContextRestoreGState(context);
}

#pragma mark Accessors

- (void)setBackgroundColor:(UIColor *)color
{
    // various built-in classes will set the background color; override
    // them and use the color as our fill color and keep super's background
    // color transparent.
    super.backgroundColor = [UIColor clearColor];

    UIColor * tmp = [color retain];
    [fillColor release];
    fillColor = tmp;

    [self setNeedsDisplay];
}

- (UIColor *)backgroundColor
{
    return fillColor;
}

@end
