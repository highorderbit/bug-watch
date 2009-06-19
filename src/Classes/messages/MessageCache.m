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
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        messages = [[NSMutableDictionary dictionary] retain];
        projectDict = [[NSMutableDictionary dictionary] retain];
        postedByDict = [[NSMutableDictionary dictionary] retain];
    }

    return self;
}

- (void)setMessage:(Message *)message forKey:(LighthouseKey *)key
{
    [messages setObject:message forKey:key];
}

- (Message *)messageForKey:(LighthouseKey *)key
{
    return [messages objectForKey:key];
}

- (NSDictionary *)allMessages
{
    return [[messages copy] autorelease];
}

- (void)setProjectKey:(NSNumber *)projectKey forKey:(LighthouseKey *)key
{
    [projectDict setObject:projectKey forKey:key];
}

- (id)projectKeyForKey:(LighthouseKey *)key
{
    return [projectDict objectForKey:key];
}

- (NSDictionary *)allProjectKeys
{
    return [[projectDict copy] autorelease];
}

- (void)setPostedByKey:(NSNumber *)postedByKey forKey:(LighthouseKey *)key
{
    [postedByDict setObject:postedByKey forKey:key];
}

- (id)postedByKeyForKey:(LighthouseKey *)key
{
    return [postedByDict objectForKey:key];
}

- (NSDictionary *)allPostedByKeys
{
    return [[postedByDict copy] autorelease];
}

- (void)merge:(MessageCache *)aMessageCache
{
    [messages addEntriesFromDictionary:aMessageCache.allMessages];
    [projectDict addEntriesFromDictionary:aMessageCache.allProjectKeys];
    [postedByDict addEntriesFromDictionary:aMessageCache.allPostedByKeys];
}

- (NSString *)description
{
    return [messages description];
}

@end
