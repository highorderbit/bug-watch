//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MilestonePersistenceStore.h"
#import "PListUtils.h"
#import "Milestone.h"

@interface MilestonePersistenceStore (Private)

+ (Milestone *)milestoneFromDictionary:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryFromMilestone:(Milestone *)milestone;
+ (NSString *)milestoneMappingsKey;
+ (NSString *)projectMappingsKey;

+ (NSString *)nameKey;
+ (NSString *)dueDateKey;
+ (NSString *)numOpenTicketsKey;
+ (NSString *)totalNumTicketsKey;
+ (NSString *)goalsKey;

@end

@implementation MilestonePersistenceStore

- (MilestoneCache *)loadFromPlist:(NSString *)plist
{
    MilestoneCache * milestoneCache =
        [[[MilestoneCache alloc] init] autorelease];

    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plist];

    NSDictionary * milestoneMappings =
        [dict objectForKey:[[self class] milestoneMappingsKey]];
    for (id key in [milestoneMappings allKeys]) {
        NSDictionary * milestoneAsDict = [milestoneMappings objectForKey:key];
        Milestone * milestone =
            [[self class] milestoneFromDictionary:milestoneAsDict];
        [milestoneCache setMilestone:milestone forKey:key];
    }

    NSDictionary * projectMappings =
        [dict objectForKey:[[self class] projectMappingsKey]];
    for (id key in [projectMappings allKeys]) {
        NSNumber * projectKey = [projectMappings objectForKey:key];
        [milestoneCache setProjectKey:projectKey forKey:key];
    }

    return milestoneCache;
}

- (void)save:(MilestoneCache *)milestoneCache toPlist:(NSString *)plist
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSMutableDictionary * milestoneMappings = [NSMutableDictionary dictionary];
    for (id key in [milestoneCache.allMilestones allKeys]) {
        Milestone * milestone = [milestoneCache milestoneForKey:key];
        NSDictionary * milestoneAsDict =
            [[self class] dictionaryFromMilestone:milestone];
        [milestoneMappings setObject:milestoneAsDict forKey:key];
    }
    
    NSMutableDictionary * projectMappings = [NSMutableDictionary dictionary];
    for (id key in [milestoneCache.allProjectMappings allKeys]) {
        NSNumber * projectKey = [milestoneCache projectKeyForKey:key];
        [milestoneMappings setObject:projectKey forKey:key];
    }

    [dict setObject:milestoneMappings
        forKey:[[self class] milestoneMappingsKey]];
    [dict setObject:projectMappings forKey:[[self class] projectMappingsKey]];

    [PlistUtils saveDictionary:dict toPlist:plist];
}

+ (Milestone *)milestoneFromDictionary:(NSDictionary *)dict
{
    NSString * name = [dict objectForKey:[[self class] nameKey]];
    NSDate * dueDate = [dict objectForKey:[[self class] dueDateKey]];
    NSNumber * numOpenTicketsAsNum =
        [dict objectForKey:[[self class] numOpenTicketsKey]];
    NSUInteger numOpenTickets = [numOpenTicketsAsNum intValue];
    NSNumber * totalNumTicketsAsNum =
        [dict objectForKey:[[self class] totalNumTicketsKey]];
    NSUInteger totalNumTickets = [totalNumTicketsAsNum intValue];
    NSString * goals = [dict objectForKey:[[self class] goalsKey]];

    return
        [[[Milestone alloc] initWithName:name dueDate:dueDate
        numOpenTickets:numOpenTickets numTickets:totalNumTickets goals:goals]
        autorelease];
}

+ (NSDictionary *)dictionaryFromMilestone:(Milestone *)milestone
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    if (milestone.name)
        [dict setObject:milestone.name forKey:[[self class] nameKey]];
    if (milestone.dueDate)
        [dict setObject:milestone.dueDate forKey:[[self class] dueDateKey]];
    [dict setObject:[NSNumber numberWithInt:milestone.numOpenTickets]
        forKey:[[self class] numOpenTicketsKey]];
    [dict setObject:[NSNumber numberWithInt:milestone.numTickets]
        forKey:[[self class] totalNumTicketsKey]];
    if (milestone.goals)
        [dict setObject:milestone.goals forKey:[[self class] goalsKey]];
        
    return dict;
}

+ (NSString *)milestoneMappingsKey
{
    return @"milestoneMappings";
}

+ (NSString *)projectMappingsKey
{
    return @"projectMappings";
}

+ (NSString *)nameKey
{
    return @"name";
}

+ (NSString *)dueDateKey
{
    return @"dueDate";
}

+ (NSString *)numOpenTicketsKey
{
    return @"numOpenTicketsKey";
}

+ (NSString *)totalNumTicketsKey
{
    return @"totalNumTickets";
}

+ (NSString *)goalsKey
{
    return @"goals";
}

@end
