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

- (void)setResponse:(MessageResponse *)response forKey:(NSNumber *)key;
- (MessageResponse *)responseForKey:(NSNumber *)key;

- (void)setAuthorKey:(NSNumber *)authorKey forKey:(NSNumber *)responseKey;
- (NSNumber *)authorKeyForKey:(NSNumber *)responseKey;

@end
