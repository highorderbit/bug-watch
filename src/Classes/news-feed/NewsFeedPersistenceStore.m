//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "NewsFeedPersistenceStore.h"
#import "PListUtils.h"
#import "NewsFeedItem.h"

@interface NewsFeedPersistenceStore (Private)

+ (NSDictionary *)dictionaryFromNewsItem:(NewsFeedItem *)newsItem;
+ (NewsFeedItem *)newsItemFromDictionary:(NSDictionary *)dictionary;

+ (NSString *)identifierKey;
+ (NSString *)typeKey;
+ (NSString *)linkKey;
+ (NSString *)publishedKey;
+ (NSString *)updatedKey;
+ (NSString *)authorKey;
+ (NSString *)titleKey;
+ (NSString *)contentKey;

@end

@implementation NewsFeedPersistenceStore

- (NSArray *)loadWithPlist:(NSString *)plist
{
    NSMutableArray * newsItems = [NSMutableArray array];
    NSArray * array = [PlistUtils getArrayFromPlist:plist];
    for (NSDictionary * newsItemAsDict in array) {
        NewsFeedItem * newsItem =
            [[self class] newsItemFromDictionary:newsItemAsDict];
        [newsItems addObject:newsItem];
    }

    return [newsItems count] > 0 ? newsItems : nil;
}

- (void)saveNewsItems:(NSArray *)newsItems toPlist:(NSString *)plist
{
    NSMutableArray * array = [NSMutableArray array];
    for (NewsFeedItem * item in newsItems) {
        NSDictionary * newsItemAsDict =
            [[self class] dictionaryFromNewsItem:item];
        [array addObject:newsItemAsDict];
    }

    [PlistUtils saveArray:array toPlist:plist];
}

+ (NSDictionary *)dictionaryFromNewsItem:(NewsFeedItem *)newsItem
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (newsItem.identifier)
        [dict setObject:newsItem.identifier
            forKey:[[self class] identifierKey]];
    if (newsItem.type)
        [dict setObject:newsItem.type forKey:[[self class] typeKey]];
    if (newsItem.link)
        [dict setObject:newsItem.link forKey:[[self class] linkKey]];
    if (newsItem.published)
        [dict setObject:newsItem.published forKey:[[self class] publishedKey]];
    if (newsItem.updated)
        [dict setObject:newsItem.updated forKey:[[self class] updatedKey]];
    if (newsItem.author)
        [dict setObject:newsItem.author forKey:[[self class] authorKey]];
    if (newsItem.title)
        [dict setObject:newsItem.title forKey:[[self class] titleKey]];
    if (newsItem.content)
        [dict setObject:newsItem.content forKey:[[self class] contentKey]];

    return dict;
}

+ (NewsFeedItem *)newsItemFromDictionary:(NSDictionary *)dict
{
    NSString * identifier = [dict objectForKey:[[self class] identifierKey]];
    NSString * type = [dict objectForKey:[[self class] typeKey]];
    NSString * link = [dict objectForKey:[[self class] linkKey]];
    NSDate * published = [dict objectForKey:[[self class] publishedKey]];
    NSDate * updated = [dict objectForKey:[[self class] updatedKey]];
    NSString * author = [dict objectForKey:[[self class] authorKey]];
    NSString * title = [dict objectForKey:[[self class] titleKey]];
    NSString * content = [dict objectForKey:[[self class] contentKey]];

    return [NewsFeedItem newsItemWithId:identifier type:type link:link
        published:published updated:updated author:author title:title
        content:content];
}

+ (NSString *)identifierKey
{
    return @"identifier";
}

+ (NSString *)typeKey
{
    return @"type";
}

+ (NSString *)linkKey
{
    return @"link";
}

+ (NSString *)publishedKey
{
    return @"published";
}

+ (NSString *)updatedKey
{
    return @"updated";
}

+ (NSString *)authorKey
{
    return @"author";
}

+ (NSString *)titleKey
{
    return @"title";
}

+ (NSString *)contentKey
{
    return @"content";
}

@end
