//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageResponse.h"

@interface MessageResponseCache : NSObject
{
    NSMutableDictionary * responses;
    NSMutableDictionary * responseAuthors;
}

- (void)setResponse:(MessageResponse *)response forKey:(id)key;
- (MessageResponse *)responseForKey:(id)key;

- (void)setAuthorKey:(id)authorKey forKey:(id)responseKey;
- (id)authorKeyForKey:(id)responseKey;

@end
