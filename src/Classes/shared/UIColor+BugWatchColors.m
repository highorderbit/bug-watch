//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UIColor+BugWatchColors.h"
#import "TicketMetaData.h"

@implementation UIColor (BugWatchColors)

+ (UIColor *)bugWatchBlueColor
{
    return [UIColor colorWithRed:0 green:.3 blue:.7 alpha:1];
}

+ (UIColor *)bugWatchGrayColor
{
    return [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
}

+ (UIColor *)bugWatchLabelColor
{
    return [UIColor colorWithRed:.318 green:.4 blue:.569 alpha:1];
}

+ (UIColor *)bugWatchBackgroundColor
{
    return [UIColor colorWithRed:.925 green:.933 blue:.953 alpha:1];
}

+ (UIColor *)bugWatchResolvedColor
{
    return [UIColor colorWithRed:.4 green:.667 blue:0 alpha:1];
}

+ (UIColor *)bugWatchNewColor
{
    return [UIColor colorWithRed:1 green:.067 blue:.467 alpha:1];
}

+ (UIColor *)bugWatchOpenColor
{
    return [UIColor colorWithRed:.667 green:.667 blue:.667 alpha:1];
}

+ (UIColor *)bugWatchHoldColor
{
    return [UIColor colorWithRed:.933 green:.733 blue:0 alpha:1];
}

+ (UIColor *)bugWatchInvalidColor
{
    return [UIColor colorWithRed:.667 green:.2 blue:0 alpha:1];
}

+ (UIColor *)bugWatchRoundedRectBackgroundColor
{
    return [UIColor colorWithRed:.549 green:.6 blue:.706 alpha:1];
}

+ (UIColor *)bugWatchSelectedCellColor
{
    return [UIColor colorWithRed:0.008 green:0.427 blue:0.925 alpha:1.0];
}

+ (UIColor *)bugWatchCheckedColor
{
    return [UIColor colorWithRed:0.196 green:0.310 blue:0.522 alpha:1.0];
}
        
+ (UIColor *)bugWatchColorForState:(NSUInteger)state
{
    UIColor * color;
    switch(state) {
        case kNew:
            color = [[self class] bugWatchNewColor];
            break;
        case kOpen:
            color = [[self class] bugWatchOpenColor];
            break;
        case kResolved:
            color = [[self class] bugWatchResolvedColor];
            break;
        case kHold:
            color = [[self class] bugWatchHoldColor];
            break;
        case kInvalid:
            color = [[self class] bugWatchInvalidColor];
            break;
    }
    
    return color;
}

+ (UIColor *)ticketEntityColor
{
    return [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1.0];
}

+ (UIColor *)milestoneEntityColor
{
    return [UIColor colorWithRed:0.533 green:0.067 blue:0.8 alpha:1.0];
}

+ (UIColor *)changesetEntityColor
{
    return [UIColor blackColor];
}

+ (UIColor *)messageEntityColor
{
    return [UIColor colorWithRed:1.0 green:0.6 blue:0.133 alpha:1.0];
}

+ (UIColor *)pageEntityColor
{
    return [UIColor colorWithRed:0 green:.667 blue:.133 alpha:1.0];
}

+ (UIColor *)unknownEntityColor
{
    return [[self class] ticketEntityColor];
}

+ (UIColor *)colorForEntity:(NSString *)entity
{
    static NSDictionary * entityColorMappings = nil;
    if (entityColorMappings == nil) {
        entityColorMappings =
        [[NSDictionary alloc] initWithObjectsAndKeys:
         [[self class] ticketEntityColor], @"ticket",
         [[self class] milestoneEntityColor], @"milestone",
         [[self class] changesetEntityColor], @"changeset",
         [[self class] messageEntityColor], @"message",
         [[self class] pageEntityColor], @"page",
         nil];
    }

    UIColor * color = [entityColorMappings objectForKey:entity];
    return color ? color : [[self class] unknownEntityColor];
}

@end
