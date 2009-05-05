//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "RoundedRectView.h"

@interface RoundedRectView ()

/*
- (void)setBackgroundColor:(UIColor *)color;
- (UIColor *)backgroundColor;
*/

@end

@implementation RoundedRectView

@synthesize roundedCornerSize, fillColor;

- (void)dealloc
{
    [fillColor release];
    [super dealloc];
}

- (void)initialize
{
    // set a reasonable default
    roundedCornerSize = CGSizeMake(7.5, 7.5);

    // save current bg color set in the nib and use for our fill color
    //[self setBackgroundColor:self.backgroundColor];
    //super.backgroundColor = [UIColor clearColor];
    self.fillColor = self.backgroundColor;
    super.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
        [self initialize];

    return self;
}

- (void)awakeFromNib
{
    [self initialize];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CGContextClearRect(context, rect);

    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);

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

- (void)setFillColor:(UIColor *)color
{
    UIColor * tmp = [color retain];
    [fillColor release];
    fillColor = tmp;

    [self setNeedsDisplay];
}

@end
