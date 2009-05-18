//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Milestone;

@interface MilestoneCache : NSObject
{
    // maps milestone number <-> milestone
    NSMutableDictionary * milestoneMappings;

    // maps milestone number <-> project key
    NSMutableDictionary * projectMappings;
}

#pragma mark Instantiation and initialization

+ (id)cache;

#pragma mark Initialization

- (id)init;

#pragma mark Milestone objects

- (void)setMilestone:(id)milestone forKey:(id)milestoneKey;
- (id)milestoneForKey:(id)milestoneKey;
- (NSDictionary *)allMilestones;

#pragma mark Project mappings

- (void)setProjectKey:(id)projectKey forKey:(id)milestoneKey;
- (id)projectKeyForKey:(id)milestoneKey;
- (NSDictionary *)allProjectMappings;

#pragma mark Clearing the cache

- (void)clear;
- (void)removeMilestonesForProjectKey:(id)key;

@end
