//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedItem.h"

@implementation NewsFeedItem

@synthesize identifier, link, published, updated, author, title, content;

- (void)dealloc
{
    [identifier release];
    [link release];
    [published release];
    [updated release];
    [author release];
    [title release];
    [content release];

    [super dealloc];
}

+ (id)newsItemWithId:(NSString *)anId link:(NSString *)aLink
    published:(NSDate *)aPubDate updated:(NSDate *)anUpdatedDate
    author:(NSString *)anAuthor title:(NSString *)aTitle
    content:(NSString *)someContent
{
    return [[[[self class] alloc] initWithId:anId link:aLink published:aPubDate
        updated:anUpdatedDate author:anAuthor title:aTitle content:someContent]
        autorelease];
}

- (id)initWithId:(NSString *)anId link:(NSString *)aLink
    published:(NSDate *)aPubDate updated:(NSDate *)anUpdatedDate
    author:(NSString *)anAuthor title:(NSString *)aTitle
    content:(NSString *)someContent
{
    if (self = [super init]) {
        identifier = [anId copy];
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
    return [NSString stringWithFormat:@"'%@': '%@'", author, title];
}

@end
