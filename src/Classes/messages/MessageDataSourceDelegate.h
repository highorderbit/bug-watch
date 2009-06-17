//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"
#import "MessageResponseCache.h"

@protocol MessageDataSourceDelegate

- (void)receivedMessagesFromDataSource:(MessageCache *)aMessageCache;
- (void)failedToFetchMessages:(NSArray *)errors;
- (void)receivedComments:(MessageResponseCache *)cache
    forMessage:(LighthouseKey *)messageKey;
- (void)failedToFetchCommentsForMessage:(LighthouseKey *)messageKey
    errors:(NSArray *)errors;
- (void)createdMessageWithKey:(LighthouseKey *)key;
- (void)failedToCreateMessage:(NSArray *)errors;

@end
