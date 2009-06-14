//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "MessageResponse.h"
#import "LighthouseKey.h"

@interface MessageCache : NSObject
{
    NSMutableDictionary * messages;
    NSMutableDictionary * projectDict;
    NSMutableDictionary * postedByDict;
    NSMutableDictionary * responseDict;
}

- (void)setMessage:(Message *)message forKey:(LighthouseKey *)key;
- (Message *)messageForKey:(LighthouseKey *)key;
- (NSDictionary *)allMessages;

- (void)setProjectKey:(NSNumber *)key forKey:(LighthouseKey *)key;
- (id)projectKeyForKey:(LighthouseKey *)key;
- (NSDictionary *)allProjectKeys;

- (void)setPostedByKey:(NSNumber *)key forKey:(LighthouseKey *)key;
- (id)postedByKeyForKey:(LighthouseKey *)key;
- (NSDictionary *)allPostedByKeys;

- (void)setResponseKeys:(NSArray *)responseKeys forKey:(LighthouseKey *)key;
- (NSArray *)responseKeysForKey:(LighthouseKey *)key;
- (NSDictionary *)allResponses;

- (void)merge:(MessageCache *)aMessageCache;

@end
