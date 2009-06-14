//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"
#import "MessageResponseCache.h"

@protocol MessageDataSourceDelegate

- (void)receivedMessagesFromDataSource:(MessageCache *)aMessageCache;
- (void)receivedComments:(MessageResponseCache *)cache
    forMessage:(LighthouseKey *)messageKey;
- (void)createdMessageWithKey:(LighthouseKey *)key;

@end
