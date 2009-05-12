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

- (void)setResponse:(MessageResponse *)response forKey:(id)key
{
    [responses setObject:response forKey:key];
}

- (MessageResponse *)responseForKey:(id)key
{
    return [responses objectForKey:key];
}

- (void)setAuthorKey:(id)authorKey forKey:(id)responseKey
{
    [responseAuthors setObject:authorKey forKey:responseKey];
}

- (id)authorKeyForKey:(id)responseKey
{
    return [responseAuthors objectForKey:responseKey];
}

@end
