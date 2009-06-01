//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MilestoneCache.h"

@interface MilestonePersistenceStore : NSObject

- (MilestoneCache *)loadFromPlist:(NSString *)plist;
- (void)save:(MilestoneCache *)state toPlist:(NSString *)plist;

@end
