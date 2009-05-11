//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageCache.h"

@implementation MessageCache

- (void)dealloc
{
    [messages release];
    [projectDict release];
    [postedByDict release];
    [responseDict release];
    
    [responses release];
    [responseAuthors release];
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        messages = [[NSMutableDictionary dictionary] retain];
        projectDict = [[NSMutableDictionary dictionary] retain];
        postedByDict = [[NSMutableDictionary dictionary] retain];
        responseDict = [[NSMutableDictionary dictionary] retain];
        responses = [[NSMutableDictionary dictionary] retain];
        responseAuthors = [[NSMutableDictionary dictionary] retain];
    }

    return self;
}

- (void)setMessage:(Message *)message forKey:(id)key
{
    [messages setObject:message forKey:key];
}

- (Message *)messageForKey:(id)key
{
    return [messages objectForKey:key];
}

- (NSDictionary *)allMessages
{
    return [[messages copy] autorelease];
}

- (void)setProjectKey:(id)projectKey forKey:(id)key
{
    [projectDict setObject:projectKey forKey:key];
}

- (id)projectKeyForKey:(id)key
{
    return [projectDict objectForKey:key];
}

- (NSDictionary *)allProjectKeys
{
    return [[projectDict copy] autorelease];
}

- (void)setPostedByKey:(id)postedByKey forKey:(id)key
{
    [postedByDict setObject:postedByKey forKey:key];
}

- (id)postedByKeyForKey:(id)key
{
    return [postedByDict objectForKey:key];
}

- (NSDictionary *)allPostedByKeys
{
    return [[postedByDict copy] autorelease];
}

- (void)setResponseKeys:(NSArray *)responseKeys forKey:(id)key
{
    [responseDict setObject: responseKeys forKey:key];
}

- (NSArray *)responseKeysForKey:(id)key
{
    return [responseDict objectForKey:key];    
}

- (void)setResponse:(MessageResponse *)response forKey:(id)key
{
    [responses setObject:response forKey:key];
}

- (MessageResponse *)responseForKey:(id)key
{
    return [responses objectForKey:key];
}

- (void)setAuthorKey:(id)authorKey forResponseKey:(id)responseKey
{
    [responseAuthors setObject:authorKey forKey:responseKey];
}

- (id)authorKeyForResponseKey:(id)responseKey
{
    return [responseAuthors objectForKey:responseKey];
}

@end