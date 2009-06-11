//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"

@interface MessagePersistenceStore : NSObject

- (MessageCache *)loadMessageCacheWithPlist:(NSString *)plist;
- (void)saveMessageCache:(MessageCache *)messageCache toPlist:(NSString *)plist;

@end
