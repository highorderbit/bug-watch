//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectCache.h"

@interface ProjectPersistenceStore : NSObject

- (ProjectCache *)loadWithPlist:(NSString *)plist;
- (void)saveProjectCache:(ProjectCache *)projectCache toPlist:(NSString *)plist;

@end
