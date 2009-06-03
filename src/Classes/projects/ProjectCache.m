//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectCache.h"

@implementation ProjectCache

- (void)dealloc
{
    [projects release];
    [projectMetadata release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        projects = [[NSMutableDictionary dictionary] retain];
        projectMetadata = [[NSMutableDictionary dictionary] retain];
    }

    return self;
}

- (void)setProject:(Project *)project forKey:(id)key
{
    [projects setObject:project forKey:key];
}

- (Project *)projectForKey:(id)key
{
    return [[projects objectForKey:key] copy];
}

- (NSDictionary *)allProjects
{
    return [[projects copy] autorelease];
}

- (void)setProjectMetadata:(ProjectMetadata *)metadata forKey:(id)key
{
    [projectMetadata setObject:metadata forKey:key];
}

- (ProjectMetadata *)projectMetadataForKey:(id)key
{
    return [[projectMetadata objectForKey:key] copy];
}

- (NSDictionary *)allProjectMetadata
{
    return [[projectMetadata copy] autorelease];
}

@end
