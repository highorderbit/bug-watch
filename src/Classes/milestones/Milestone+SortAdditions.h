//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Milestone.h"

@interface Milestone (SortAdditions)

- (NSComparisonResult)dueDateCompare:(Milestone *)anotherMilestone;

@end
