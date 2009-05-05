//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MilestoneProgressView : UIView
{
    UIView * progressView;
    UIView * remainingView;

    /*
    UIColor * outlineColor;
    UIColor * progressColor;
    UIColor * remainingColor;
    */

    float progress;
}

@property (nonatomic, retain) UIColor * outlineColor;
@property (nonatomic, retain) UIColor * progressColor;
@property (nonatomic, retain) UIColor * remainingColor;

@property (nonatomic) float progress;

@end
