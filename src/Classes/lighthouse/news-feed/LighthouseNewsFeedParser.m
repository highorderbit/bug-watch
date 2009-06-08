//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseNewsFeedParser.h"
#import "NewsFeedItem.h"
#import "NSDate+StringHelpers.h"
#import "RegexKitLite.h"

@interface LighthouseNewsFeedParser (Private)

- (void)resetContext;

- (void)setCurrentItem:(NewsFeedItem *)item;
- (void)setContext:(NSString *)aContext;
- (void)setValue:(NSMutableString *)aValue;
- (void)setFeed:(NSArray *)aFeed;

+ (NSString *)extractTypeFromTitle:(NSString *)title;
+ (NSDate *)dateFromString:(NSString *)s;

@end

@implementation LighthouseNewsFeedParser

- (void)dealloc
{
    [currentItem release];
    [context release];
    [value release];
    [feed release];

    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        currentItem = nil;
        context = nil;
        value = nil;
        feed = nil;
    }

    return self;
}

- (NSArray *)parse:(NSData *)xml
{
    [self setFeed:[NSMutableArray array]];

    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:xml];
    parser.delegate = self;
    [parser parse];
    [parser release];

    NSLog(@"Returning: %@.", feed);
    return feed;
}

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributes
{
    if ([elementName isEqualToString:@"entry"])
        currentItem = [[NewsFeedItem alloc] init];
    else if (currentItem) {
        [self setContext:elementName];
        [self setValue:[NSMutableString string]];
    }

    if (currentItem && [elementName isEqualToString:@"link"])
        [currentItem setValue:[attributes objectForKey:@"href"] forKey:@"link"];
    else if (currentItem && [elementName isEqualToString:@"id"])
        [self setContext:@"identifier"];
    else if (currentItem && [elementName isEqualToString:@"author"])
        [self resetContext];
    else if (currentItem && [elementName isEqualToString:@"name"])
        [self setContext:@"author"];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"entry"]) {
        NSString * type = [[self class] extractTypeFromTitle:currentItem.title];
        [currentItem setValue:type forKey:@"type"];
        [feed addObject:currentItem];
        [self setCurrentItem:nil];
    } else if (currentItem && context && ![context isEqualToString:@"link"]) {
        [currentItem setValue:value forKey:context];
        [self resetContext];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([context isEqual:@"published"] || [context isEqual:@"updated"]) {
        NSDate * date = [[self class] dateFromString:string];
        [currentItem setValue:date forKey:context];
        [self resetContext];
    } else if (context)
        [value appendString:string];
}

#pragma mark Tracking state

- (void)resetContext
{
    [self setContext:nil];
    [self setValue:[NSMutableString string]];
}

#pragma mark Accessors

- (void)setCurrentItem:(NewsFeedItem *)item
{
    NewsFeedItem * tmp = [item copy];
    [currentItem release];
    currentItem = tmp;
}

- (void)setContext:(NSString *)aContext
{
    NSString * tmp = [aContext copy];
    [context release];
    context = tmp;
}

- (void)setValue:(NSMutableString *)aValue
{
    NSMutableString * tmp = [aValue mutableCopy];
    [value release];
    value = tmp;
}

- (void)setFeed:(NSArray *)aFeed
{
    NSMutableArray * tmp = [aFeed mutableCopy];
    [feed release];
    feed = tmp;
}

+ (NSDate *)dateFromString:(NSString *)s
{
    // Example string: 2009-03-13T11:40:32-07:00
    return [NSDate dateFromString:s format:@"yyyy-MM-dd'T'HH:mm:SSZZZ"];
}

+ (NSString *)extractTypeFromTitle:(NSString *)title
{
    // is the type specified at the start?
    NSString * type = [title stringByMatching:@"^\\[(.+)\\]" capture:1];
    if (!type) {
        // does it end in a ticket number?
        type = [title stringByMatching:@"\\[#\\d+\\]"];
        if (type)
            type = NSLocalizedString(@"newsfeed.item.type.ticket", @"");
        else  // assume it is a bulk edit operation
            type = NSLocalizedString(@"newsfeed.item.type.bulkedit", @"");
    }

    return [type lowercaseString];
}

@end