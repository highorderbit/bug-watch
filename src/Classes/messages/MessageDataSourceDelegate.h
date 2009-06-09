//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"

@protocol MessageDataSourceDelegate

- (void)receivedMessagesFromDataSource:(MessageCache *)aMessageCache;
- (void)createdMessageWithKey:(id)key;

@end
