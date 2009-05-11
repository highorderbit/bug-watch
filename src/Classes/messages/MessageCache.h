//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message.h"
#import "MessageResponse.h"

@interface MessageCache : NSObject
{
    NSMutableDictionary * messages;
    NSMutableDictionary * projectDict;
    NSMutableDictionary * postedByDict;
    NSMutableDictionary * responseDict;
    
    NSMutableDictionary * responses;
    NSMutableDictionary * responseAuthors;
}

- (void)setMessage:(Message *)message forKey:(id)key;
- (Message *)messageForKey:(id)key;
- (NSDictionary *)allMessages;

- (void)setProjectKey:(id)key forKey:(id)key;
- (id)projectKeyForKey:(id)key;
- (NSDictionary *)allProjectKeys;

- (void)setPostedByKey:(id)key forKey:(id)key;
- (id)postedByKeyForKey:(id)key;
- (NSDictionary *)allPostedByKeys;

- (void)setResponseKeys:(NSArray *)responseKeys forKey:(id)key;
- (NSArray *)responseKeysForKey:(id)key;

- (void)setResponse:(MessageResponse *)response forKey:(id)key;
- (MessageResponse *)responseForKey:(id)key;

- (void)setAuthorKey:(id)authorKey forResponseKey:(id)responseKey;
- (id)authorKeyForResponseKey:(id)responseKey;

@end
