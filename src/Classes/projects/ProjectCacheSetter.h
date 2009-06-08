//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectCache.h"

@interface ProjectCacheSetter : NSObject
{
    ProjectCache * cache;
}

@property (nonatomic, readonly) ProjectCache * cache;

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;

@end
