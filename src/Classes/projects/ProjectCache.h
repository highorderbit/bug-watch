//
//  This class is currently just a wrapper around a dictionary, but will serve
//  as a placeholder in case other attribute mappings are added
//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"

@interface ProjectCache : NSObject
{
    NSMutableDictionary * projects;
}

- (void)setProject:(Project *)project forKey:(id)key;
- (Project *)projectForKey:(id)key;
- (NSDictionary *)allProjects;

@end
