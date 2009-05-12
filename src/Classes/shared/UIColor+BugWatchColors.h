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
+ (UIColor *)bugWatchRoundedRectBackgroundColor;
+ (UIColor *)bugWatchSelectedCellColor;
+ (UIColor *)bugWatchCheckedColor;

+ (UIColor *)bugWatchColorForState:(NSUInteger)state;

+ (UIColor *)ticketEntityColor;
+ (UIColor *)milestoneEntityColor;
+ (UIColor *)changesetEntityColor;
+ (UIColor *)messageEntityColor;
+ (UIColor *)pageEntityColor;
+ (UIColor *)replyEntityColor;
+ (UIColor *)unknownEntityColor;

+ (UIColor *)colorForEntity:(NSString *)entity;

+ (UIColor *)milestoneProgressColor;
+ (UIColor *)lateMilestoneProgressColor;

+ (UIColor *)selectedTableViewCellBackgroundColor;

@end
