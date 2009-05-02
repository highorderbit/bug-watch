//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedRectLabel : UIView
{
    CGFloat roundedRectRed;
    CGFloat roundedRectGreen;
    CGFloat roundedRectBlue;
    CGFloat roundedRectAlpha;
    
    CGFloat roundedCornerWidth;
    CGFloat roundedCornerHeight;
    
    UILabel * label;
}

@property (nonatomic, assign) CGFloat roundedRectRed;
@property (nonatomic, assign) CGFloat roundedRectGreen;
@property (nonatomic, assign) CGFloat roundedRectBlue;
@property (nonatomic, assign) CGFloat roundedRectAlpha;

@property (nonatomic, assign) CGFloat roundedCornerWidth;
@property (nonatomic, assign) CGFloat roundedCornerHeight;

@property (nonatomic, copy) NSString * text;
@property (nonatomic, retain) UIFont * font;

@end
