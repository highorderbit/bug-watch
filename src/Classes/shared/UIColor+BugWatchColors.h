//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (BugWatchColors)

+ (UIColor *)bugWatchBlueColor;
+ (UIColor *)bugWatchGrayColor;
+ (UIColor *)bugWatchLabelColor;
+ (UIColor *)bugWatchBackgroundColor;
+ (UIColor *)bugWatchResolvedColor;
+ (UIColor *)bugWatchNewColor;
+ (UIColor *)bugWatchOpenColor;
+ (UIColor *)bugWatchHoldColor;
+ (UIColor *)bugWatchInvalidColor;

+ (UIColor *)bugWatchColorForState:(NSUInteger)state;

@end
