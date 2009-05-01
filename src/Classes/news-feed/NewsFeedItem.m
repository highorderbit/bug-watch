//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedItem.h"
// TODO: Remove after dummy data has been removed.
#import "NSDate+LighthouseStringHelpers.h"

@implementation NewsFeedItem

@synthesize identifier, type, link, published, updated, author, title, content;

- (void)dealloc
{
    [identifier release];
    [type release];
    [link release];
    [published release];
    [updated release];
    [author release];
    [title release];
    [content release];

    [super dealloc];
}

+ (id)newsItemWithId:(NSString *)anId type:(NSString *)aType
    link:(NSString *)aLink published:(NSDate *)aPubDate
    updated:(NSDate *)anUpdatedDate author:(NSString *)anAuthor
    title:(NSString *)aTitle content:(NSString *)someContent
{
    return [[[[self class] alloc] initWithId:anId type:aType link:aLink
        published:aPubDate updated:anUpdatedDate author:anAuthor title:aTitle
        content:someContent] autorelease];
}

- (id)initWithId:(NSString *)anId type:(NSString *)aType link:(NSString *)aLink
    published:(NSDate *)aPubDate updated:(NSDate *)anUpdatedDate
    author:(NSString *)anAuthor title:(NSString *)aTitle
    content:(NSString *)someContent
{
    if (self = [super init]) {
        identifier = [anId copy];
        type = [aType copy];
        link = [aLink copy];
        published = [aPubDate copy];
        updated = [anUpdatedDate copy];
        author = [anAuthor copy];
        title = [aTitle copy];
        content = [someContent copy];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];  // immutable
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"'%@': '%@': '%@'", type, author, title];
}

#pragma mark Dummy data

+ (NSArray *)dummyData
{
    NSArray * authors =
        [NSArray arrayWithObjects:
        @"John A. Debay",
        @"John A. Debay",
        @"Doug Kurth",
        @"John A. Debay",
        @"Doug Kurth",
        @"Doug Kurth",
        @"John A. Debay",
        @"John A. Debay",
        @"Doug Kurth",
        @"John A. Debay",
        nil
        ];

    NSArray * pubDates =
        [NSArray arrayWithObjects:
        [NSDate dateWithLighthouseString:@"2009-04-29T10:22:06-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T10:21:54-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T10:16:53-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T10:16:32-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-29T09:38:58-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T23:24:43-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T22:30:53-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T22:29:56-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T22:28:42-06:00"],
        [NSDate dateWithLighthouseString:@"2009-04-28T20:59:40-06:00"],
        nil
        ];

    NSArray * titles =
        [NSArray arrayWithObjects:
        @"Code Watch: Add followed users to user info view [#231]",
        @"Changeset [33b9d1aafd6c05920cec8a7bf386a5ec7a56c435] by "
         "John A. Debay",
        @"Code Watch: Add following to user info view [#232]",
        @"Code Watch: App Store Description was posted",
        @"Code Watch: Set background color for modal views [#233]",
        @"[Milestone] Code Watch: 1.1.1",
        @"Code Watch: Set background color for modal views [#233]",
        @"Code Watch: Make location cell clicks in user info view open maps "
         "[#229]",
        @"Code Watch: Better distinguish private and public repo icons [#235]",
        @"Code Watch: Better distinguish private and public repo icons [#235]",
        @"Code Watch: Opening user location in maps doesn't work [#234]",
        //@"Code Watch: Add privacy icon to repo name cells [#228]",
        //@"Code Watch: Set background color for modal views [#233]",
        //@"Code Watch: Add disclosure indicators to news feed [#225]",
        nil
        ];

    NSArray * entityTypes =
        [NSArray arrayWithObjects:
        @"ticket",
        @"changeset",
        @"ticket",
        @"message",
        @"ticket",
        @"milestone",
        @"ticket",
        @"ticket",
        @"ticket",
        @"ticket",
        nil
        ];


    NSMutableArray * items = [NSMutableArray array];
    for (int i = 0; i < authors.count; ++i) {
        NewsFeedItem * item = [[NewsFeedItem alloc] init];

        [item setValue:[authors objectAtIndex:i] forKey:@"author"];
        [item setValue:[pubDates objectAtIndex:i] forKey:@"published"];
        [item setValue:[titles objectAtIndex:i] forKey:@"title"];
        [item setValue:[entityTypes objectAtIndex:i] forKey:@"type"];

        [items addObject:item];

        [item release];
    }

    return items;
}

@end
