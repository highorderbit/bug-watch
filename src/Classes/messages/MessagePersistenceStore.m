//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessagePersistenceStore.h"
#import "Message.h"
#import "PlistUtils.h"

@interface MessagePersistenceStore (Private)

+ (NSDictionary *)dictionaryFromMessage:(Message *)message;
+ (Message *)messageFromDictionary:(NSDictionary *)dict;

+ (NSString *)postedDateKey;
+ (NSString *)titleKey;
+ (NSString *)messageKey;

+ (NSString *)messagesKey;
+ (NSString *)projectDictKey;
+ (NSString *)postedByDictKey;
+ (NSString *)responseDictKey;

@end

@implementation MessagePersistenceStore

- (MessageCache *)loadMessageCacheWithPlist:(NSString *)plist
{
    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plist];

    if (![dict objectForKey:[[self class] messagesKey]]) {
        NSLog(@"Loading 'nil' message cache...");
        return nil;
    }

    MessageCache * messageCache = [[[MessageCache alloc] init] autorelease];

    NSDictionary * messages =
        [dict objectForKey:[[self class] messagesKey]];
    NSDictionary * projectDict =
        [dict objectForKey:[[self class] projectDictKey]];
    NSDictionary * postedByDict =
        [dict objectForKey:[[self class] postedByDictKey]];
    NSDictionary * responseDict =
        [dict objectForKey:[[self class] responseDictKey]];

    for (NSString * keyAsString in [messages allKeys]) {
        NSNumber * key = [NSNumber numberWithInt:[keyAsString intValue]];
        NSDictionary * messageFieldsDict =
            [messages objectForKey:keyAsString];
        Message * message =
            [[self class] messageFromDictionary:messageFieldsDict];
        if (message)
            [messageCache setMessage:message forKey:key];

        id projectKey = [projectDict objectForKey:keyAsString];
        if (projectKey)
            [messageCache setProjectKey:projectKey forKey:key];

        id postedByKey = [postedByDict objectForKey:keyAsString];
        if (postedByKey)
            [messageCache setPostedByKey:postedByKey forKey:key];

        NSArray * responseKeys = [responseDict objectForKey:keyAsString];
        if (responseKeys)
            [messageCache setResponseKeys:responseKeys forKey:key];
    }

    return messageCache;
}

- (void)saveMessageCache:(MessageCache *)messageCache toPlist:(NSString *)plist
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableDictionary * messages = [NSMutableDictionary dictionary];
    NSMutableDictionary * projectDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postedByDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * responseDict = [NSMutableDictionary dictionary];

    NSDictionary * allMessages = [messageCache allMessages];
    for (NSNumber * key in [allMessages allKeys]) {
        Message * message = [allMessages objectForKey:key];
        NSDictionary * messageFieldDict =
            [[self class] dictionaryFromMessage:message];
        [messages setObject:messageFieldDict forKey:[key description]];
    }

    NSDictionary * allProjectKeys = [messageCache allProjectKeys];
    for (NSNumber * key in [allProjectKeys allKeys]) {
        NSNumber * projectKey = [allProjectKeys objectForKey:key];
        [projectDict setObject:projectKey forKey:[key description]];
    }

    NSDictionary * allPostedByKeys = [messageCache allPostedByKeys];
    for (NSNumber * key in [allPostedByKeys allKeys]) {
        NSNumber * postedByKey = [allPostedByKeys objectForKey:key];
        [postedByDict setObject:postedByKey forKey:[key description]];
    }

    NSDictionary * allResponses = [messageCache allResponses];
    for (NSNumber * key in [allResponses allKeys]) {
        NSArray * responseKeys = [allResponses objectForKey:key];
        [responseDict setObject:responseKeys forKey:[key description]];
    }

    [dict setObject:messages forKey:[[self class] messagesKey]];
    [dict setObject:projectDict forKey:[[self class] projectDictKey]];
    [dict setObject:postedByDict forKey:[[self class] postedByDictKey]];
    [dict setObject:responseDict forKey:[[self class] responseDictKey]];

    NSLog(@"Message cache: %@", dict);
    [PlistUtils saveDictionary:dict toPlist:plist];
}

#pragma mark Data conversion methods

+ (NSDictionary *)dictionaryFromMessage:(Message *)message
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    if (message.postedDate)
        [dict setObject:message.postedDate forKey:[[self class] postedDateKey]];
    if (message.title)
        [dict setObject:message.title forKey:[[self class] titleKey]];
    if (message.message)
        [dict setObject:message.message forKey:[[self class] messageKey]];

    return dict;
}

+ (Message *)messageFromDictionary:(NSDictionary *)dict
{
    NSDate * postedDate = [dict objectForKey:[[self class] postedDateKey]];
    NSString * title = [dict objectForKey:[[self class] titleKey]];
    NSString * message = [dict objectForKey:[[self class] messageKey]];

    return [[[Message alloc]
        initWithPostedDate:postedDate title:title message:message]
        autorelease];
}

#pragma mark String constants

+ (NSString *)postedDateKey
{
    return @"postedDate";
}

+ (NSString *)titleKey
{
    return @"title";
}

+ (NSString *)messageKey
{
    return @"message";
}

+ (NSString *)messagesKey
{
    return @"messages";
}

+ (NSString *)projectDictKey
{
    return @"projectDict";
}

+ (NSString *)postedByDictKey
{
    return @"postedByDict";
}

+ (NSString *)responseDictKey
{
    return @"responseDict";
}

@end