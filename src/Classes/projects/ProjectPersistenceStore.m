//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectPersistenceStore.h"
#import "PListUtils.h"

@interface ProjectPersistenceStore (Private)

+ (Project *)projectFromDictionary:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryFromProject:(Project *)project;
+ (ProjectMetadata *)projectMetadataFromDictionary:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryFromProjectMetadata:(ProjectMetadata *)metadata;

+ (NSString *)projectsKey;
+ (NSString *)projectMetadataKey;

+ (NSString *)nameKey;
+ (NSString *)openTicketsCountKey;

@end

@implementation ProjectPersistenceStore

- (ProjectCache *)loadWithPlist:(NSString *)plist
{
    ProjectCache * projectCache = [[[ProjectCache alloc] init] autorelease];
    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plist];
    
    NSDictionary * projectsDict =
        [dict objectForKey:[[self class] projectsKey]];
    NSDictionary * projectMetadataDict =
        [dict objectForKey:[[self class] projectMetadataKey]];

    for (NSString * keyAsString in [projectsDict allKeys]) {
        NSDictionary * projectAsDict = [projectsDict objectForKey:keyAsString];
        NSNumber * key = [NSNumber numberWithInt:[keyAsString intValue]];
        Project * project = [[self class] projectFromDictionary:projectAsDict];
        [projectCache setProject:project forKey:key];
    }

    for (NSString * keyAsString in [projectMetadataDict allKeys]) {
        NSDictionary * metadataAsDict = [projectsDict objectForKey:keyAsString];
        NSNumber * key = [NSNumber numberWithInt:[keyAsString intValue]];
        ProjectMetadata * metadata =
            [[self class] projectMetadataFromDictionary:metadataAsDict];
        [projectCache setProjectMetadata:metadata forKey:key];
    }

    return projectCache;
}

- (void)saveProjectCache:(ProjectCache *)projectCache toPlist:(NSString *)plist
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    NSDictionary * projectDict = [projectCache allProjects];
    NSMutableDictionary * serProjectDict = [NSMutableDictionary dictionary];
    for (NSNumber * key in [projectDict allKeys]) {
        Project * project = [projectDict objectForKey:key];
        NSDictionary * projectAsDict =
            [[self class] dictionaryFromProject:project];
        [serProjectDict setObject:projectAsDict forKey:[key description]];
    }
    
    [dict setObject:serProjectDict forKey:[[self class] projectsKey]];

    NSDictionary * metadataDict = [projectCache allProjectMetadata];
    NSMutableDictionary * serMetadataDict = [NSMutableDictionary dictionary];
    for (NSNumber * key in [metadataDict allKeys]) {
        ProjectMetadata * metadata = [metadataDict objectForKey:key];
        NSDictionary * metadataAsDict =
            [[self class] dictionaryFromProjectMetadata:metadata];
        [serMetadataDict setObject:metadataAsDict forKey:[key description]];
    }
    
    [dict setObject:serMetadataDict forKey:[[self class] projectMetadataKey]];

    [PlistUtils saveDictionary:dict toPlist:plist];
}

+ (Project *)projectFromDictionary:(NSDictionary *)dict
{
    NSString * name = [dict objectForKey:[[self class] nameKey]];

    return [[[Project alloc] initWithName:name] autorelease];
}

+ (NSDictionary *)dictionaryFromProject:(Project *)project
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (project.name)
        [dict setObject:project.name forKey:[[self class] nameKey]];

    return dict;
}

+ (ProjectMetadata *)projectMetadataFromDictionary:(NSDictionary *)dict
{
    NSNumber * openTicketsCountAsNumber =
        [dict objectForKey:[[self class] openTicketsCountKey]];
    NSUInteger openTicketsCount = [openTicketsCountAsNumber intValue];

    return [[[ProjectMetadata alloc] initWithOpenTicketsCount:openTicketsCount]
        autorelease];
}

+ (NSDictionary *)dictionaryFromProjectMetadata:(ProjectMetadata *)metadata
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSNumber numberWithInt:metadata.openTicketsCount]
        forKey:[[self class] openTicketsCountKey]];

    return dict;
}

+ (NSString *)projectsKey
{
    return @"projects";
}

+ (NSString *)projectMetadataKey
{
    return @"projectMetadata";
}

+ (NSString *)nameKey
{
    return @"name";
}

+ (NSString *)openTicketsCountKey
{
    return @"openTicketsCountKey";
}

@end
