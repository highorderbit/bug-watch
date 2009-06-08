//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectDispMgrProjectSetter.h"

@implementation ProjectDispMgrProjectSetter

- (void)dealloc
{
    [projectDisplayMgr release];
    [super dealloc];
}

- (id)initWithProjectDisplayMgr:(ProjectDisplayMgr *)aProjectDisplayMgr
{
    if (self = [super init])
        projectDisplayMgr = [aProjectDisplayMgr retain];

    return self;
}

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys
{
    ProjectCache * projectCache = [[[ProjectCache alloc] init] autorelease];
    for (int i = 0; i < [keys count]; i++) {
        id key = [keys objectAtIndex:i];
        Project * project = [projects objectAtIndex:i];
        [projectCache setProject:project forKey:key];
    }

    projectDisplayMgr.projectCache = projectCache;
}

@end
