//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedRectLabel : UIControl
{
    UIColor * roundedRectColor;
    UIColor * highlightedRoundedRectColor;

    CGFloat roundedCornerWidth;
    CGFloat roundedCornerHeight;

    UILabel * label;
}

@property (nonatomic, retain) UIColor * roundedRectColor;
@property (nonatomic, retain) UIColor * highlightedRoundedRectColor;

@property (nonatomic, assign) CGFloat roundedCornerWidth;
@property (nonatomic, assign) CGFloat roundedCornerHeight;

@property (nonatomic, copy) NSString * text;
@property (nonatomic, retain) UIFont * font;

@end
