//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageResponseCache.h"

@implementation MessageResponseCache

- (void)dealloc
{
    [responses release];
    [responseAuthors release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        responses = [[NSMutableDictionary dictionary] retain];
        responseAuthors = [[NSMutableDictionary dictionary] retain];
    }

    return self;
}

- (void)setResponse:(MessageResponse *)response forKey:(NSNumber *)key
{
    [responses setObject:response forKey:key];
}

- (MessageResponse *)responseForKey:(NSNumber *)key
{
    return [responses objectForKey:key];
}

- (void)setAuthorKey:(NSNumber *)authorKey forKey:(NSNumber *)responseKey
{
    [responseAuthors setObject:authorKey forKey:responseKey];
}

- (NSNumber *)authorKeyForKey:(NSNumber *)responseKey
{
    return [responseAuthors objectForKey:responseKey];
}

- (NSString *)description
{
    return [responses description];
}

@end
