//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserPersistenceStore.h"
#import "PListUtils.h"

@interface UserPersistenceStore (Private)

+ (User *)userFromDictionary:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryFromUser:(User *)user;

+ (NSString *)nameKey;
+ (NSString *)jobKey;
+ (NSString *)websiteLinkKey;
+ (NSString *)avatarLinkKey;

@end

@implementation UserPersistenceStore

- (UserCache *)loadWithPlist:(NSString *)plist
{
    UserCache * userCache = [[[UserCache alloc] init] autorelease];
    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plist];
    for (id key in [dict allKeys]) {
        NSDictionary * userAsDict = [dict objectForKey:key];
        User * user = [[self class] userFromDictionary:userAsDict];
        [userCache setUser:user forKey:key];
    }

    return userCache;
}

- (void)saveUserCache:(UserCache *)userCache toPlist:(NSString *)plist
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSDictionary * userDict = [userCache allUsers];
    for (id key in [userDict allKeys]) {
        User * user = [userDict objectForKey:key];
        NSDictionary * userAsDict = [[self class] dictionaryFromUser:user];
        [dict setObject:userAsDict forKey:key];
    }

    [PlistUtils saveDictionary:dict toPlist:plist];
}

+ (User *)userFromDictionary:(NSDictionary *)dict
{
    NSString * name = [dict objectForKey:[[self class] nameKey]];
    NSString * job = [dict objectForKey:[[self class] jobKey]];
    NSString * websiteLink = [dict objectForKey:[[self class] websiteLinkKey]];
    NSString * avatarLink = [dict objectForKey:[[self class] avatarLinkKey]];

    return [[[User alloc]
        initWithName:name job:job websiteLink:websiteLink avatarLink:avatarLink]
        autorelease];
}

+ (NSDictionary *)dictionaryFromUser:(User *)user
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    if (user.name)
        [dict setObject:user.name forKey:[[self class] nameKey]];
    if (user.job)
        [dict setObject:user.job forKey:[[self class] jobKey]];
    if (user.websiteLink)
        [dict setObject:user.websiteLink forKey:[[self class] websiteLinkKey]];
    if (user.avatarLink)
        [dict setObject:user.avatarLink forKey:[[self class] avatarLinkKey]];

    return dict;
}

+ (NSString *)nameKey
{
    return @"name";
}

+ (NSString *)jobKey
{
    return @"job";
}

+ (NSString *)websiteLinkKey
{
    return @"websiteLink";
}

+ (NSString *)avatarLinkKey
{
    return @"avatarLink";
}

@end
