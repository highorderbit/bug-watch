//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NSArray+IterationAdditions.h"

@implementation NSArray (IterationAdditions)

- (NSArray *)arrayByFilteringObjectsUsingSelector:(SEL)sel
{
    NSMutableArray * filteredArray =
        [NSMutableArray arrayWithCapacity:self.count];

    for (id obj in self)
        if ([obj performSelector:sel])
            [filteredArray addObject:obj];

    return filteredArray;
}

@end
