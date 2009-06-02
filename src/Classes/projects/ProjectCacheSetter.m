//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectCacheSetter.h"

@interface ProjectCacheSetter (Private)

- (void)setCache:(ProjectCache *)projectCache;

@end

@implementation ProjectCacheSetter

@synthesize cache;

- (void)dealloc
{
    [cache release];
    [super dealloc];
}

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys
{
    ProjectCache * newCache = [[ProjectCache alloc] init];
    for (int i = 0; i < [projects count]; i++) {
        id key = [keys objectAtIndex:i];
        Project * project = [projects objectAtIndex:i];
        [newCache setProject:project forKey:key];
    }
    
    [self setCache:newCache];
}

- (void)setCache:(ProjectCache *)aCache
{
    [aCache retain];
    [cache release];
    cache = aCache;
}

@end
