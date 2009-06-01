//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCache.h"

@interface UserPersistenceStore : NSObject

- (UserCache *)loadWithPlist:(NSString *)plist;
- (void)saveUserCache:(UserCache *)userCache toPlist:(NSString *)plist;

@end
