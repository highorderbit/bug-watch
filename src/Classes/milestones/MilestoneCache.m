//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneCache.h"
#import "NSArray+IterationAdditions.h"

@implementation MilestoneCache

#pragma mark Instantiation and initialization

+ (id)cache
{
    return [[[[self class] alloc] init] autorelease];
}

#pragma mark Instantiation

- (void)dealloc
{
    [milestoneMappings release];
    [projectMappings release];
    [super dealloc];
}

#pragma mark Initialization

- (id)init
{
    if (self = [super init]) {
        milestoneMappings = [[NSMutableDictionary alloc] init];
        projectMappings = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Milestone objects

- (void)setMilestone:(id)milestone forKey:(id)milestoneKey
{
    [milestoneMappings setObject:milestone forKey:milestoneKey];
}

- (id)milestoneForKey:(id)milestoneKey
{
    return [[[milestoneMappings objectForKey:milestoneKey] copy] autorelease];
}

- (NSDictionary *)allMilestones
{
    return [[milestoneMappings copy] autorelease];
}

#pragma mark Project mappings

- (void)setProjectKey:(id)projectKey forKey:(id)milestoneKey
{
    [projectMappings setObject:projectKey forKey:milestoneKey];
}

- (id)projectKeyForKey:(id)milestoneKey
{
    return [projectMappings objectForKey:milestoneKey];
}

- (NSDictionary *)allProjectMappings
{
    return [[projectMappings copy] autorelease];
}

- (void)addMilestones:(NSArray *)milestones
    withMilestoneKeys:(NSArray *)milestoneKeys
           projectKey:(id)projectKey
{
    for (NSInteger i = 0, count = milestones.count; i < count; ++i) {
        id milestone = [milestones objectAtIndex:i];
        id milestoneKey = [milestoneKeys objectAtIndex:i];

        [self setMilestone:milestone forKey:milestoneKey];
        [self setProjectKey:projectKey forKey:milestoneKey];
    }
}

- (void)setMilestones:(NSArray *)milestones
    withMilestoneKeys:(NSArray *)milestoneKeys
           projectKey:(id)projectKey
{
    [self removeMilestonesForProjectKey:projectKey];
    [self addMilestones:milestones
      withMilestoneKeys:milestoneKeys
             projectKey:projectKey];
}

#pragma mark Clearing the cache

- (void)clear
{
    [milestoneMappings removeAllObjects];
    [projectMappings removeAllObjects];
}

- (void)removeMilestonesForProjectKey:(id)key
{
    NSArray * milestoneKeys =
        [projectMappings.allValues
        arrayByFilteringObjectsUsingSelector:@selector(isEqual:)
                                  withObject:key];

    for (id milestoneKey in milestoneKeys) {
        [milestoneMappings removeObjectForKey:milestoneKey];
        [projectMappings removeObjectForKey:milestoneKey];
    }
}

@end
