//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectPersistenceStore.h"
#import "PListUtils.h"

@interface ProjectPersistenceStore (Private)

+ (Project *)projectFromString:(NSString *)string;
+ (NSString *)stringFromProject:(Project *)project;

@end

@implementation ProjectPersistenceStore

- (ProjectCache *)loadWithPlist:(NSString *)plist
{
    ProjectCache * projectCache = [[[ProjectCache alloc] init] autorelease];
    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plist];
    for (NSString * keyAsString in [dict allKeys]) {
        NSString * projectAsString = [dict objectForKey:keyAsString];
        NSNumber * key = [NSNumber numberWithInt:[keyAsString intValue]];
        Project * project = [[self class] projectFromString:projectAsString];
        [projectCache setProject:project forKey:key];
    }

    return projectCache;
}

- (void)saveProjectCache:(ProjectCache *)projectCache toPlist:(NSString *)plist
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSDictionary * projectDict = [projectCache allProjects];
    for (NSNumber * key in [projectDict allKeys]) {
        Project * project = [projectDict objectForKey:key];
        NSString * projectAsString = [[self class] stringFromProject:project];
        [dict setObject:projectAsString forKey:[key description]];
    }

    NSLog(@"Projects: %@", dict);
    [PlistUtils saveDictionary:dict toPlist:plist];
}

+ (Project *)projectFromString:(NSString *)string
{
    return [[[Project alloc] initWithName:string] autorelease];
}

+ (NSString *)stringFromProject:(Project *)project
{
    return project.name;
}

@end
