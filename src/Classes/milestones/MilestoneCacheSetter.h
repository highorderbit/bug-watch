//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MilestoneCache.h"

@interface MilestoneCacheSetter : NSObject
{
    MilestoneCache * cache;
}

@property (nonatomic, readonly) MilestoneCache * cache;

- (void)milestonesReceivedForAllProjects:(NSArray *)milestones
    milestoneKeys:(NSArray *)milestoneKeys projectKeys:(NSArray *)projectKeys;

@end
