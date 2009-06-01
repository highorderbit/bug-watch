//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsFeedPersistenceStore : NSObject

- (NSArray *)loadWithPlist:(NSString *)plist;
- (void)saveNewsItems:(NSArray *)newsItems toPlist:(NSString *)plist;

@end
