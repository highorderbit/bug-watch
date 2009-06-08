//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MilestoneCacheSetter.h"

@interface MilestoneCacheSetter (Private)

- (void)setCache:(MilestoneCache *)aCache;

@end

@implementation MilestoneCacheSetter

@synthesize cache;

- (void)dealloc
{
    [cache release];
    [super dealloc];
}

- (void)milestonesReceivedForAllProjects:(NSArray *)milestones
    milestoneKeys:(NSArray *)milestoneKeys projectKeys:(NSArray *)projectKeys
{
    NSLog(@"Setting milestone cache...");

    MilestoneCache * newCache = [[[MilestoneCache alloc] init] autorelease];
    for (int i = 0; i < [milestones count]; i++) {
        id key = [milestoneKeys objectAtIndex:i];
        Milestone * milestone = [milestones objectAtIndex:i];
        [newCache setMilestone:milestone forKey:key];
        id projectKey = [projectKeys objectAtIndex:i];
        [newCache setProjectKey:projectKey forKey:key];
    }

    [self setCache:newCache];
}

- (void)setCache:(MilestoneCache *)aCache
{
    [aCache retain];
    [cache release];
    cache = aCache;
}

@end
