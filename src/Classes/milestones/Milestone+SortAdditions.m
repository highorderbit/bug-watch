//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "Milestone+SortAdditions.h"

@implementation Milestone (SortAdditions)

- (NSComparisonResult)dueDateCompare:(Milestone *)anotherMilestone
{
    if (self.dueDate == nil)
        return anotherMilestone.dueDate ? NSOrderedDescending : NSOrderedSame;
    else if (anotherMilestone.dueDate == nil)
        return NSOrderedAscending;
    else
        return [self.dueDate compare:anotherMilestone.dueDate];
}

@end
