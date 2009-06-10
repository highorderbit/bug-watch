//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "BugWatchObjectBuilder.h"
#import "LighthouseApiParser.h"

@interface BugWatchObjectBuilder ()

@property (nonatomic, retain) LighthouseApiParser * parser;

@end

@implementation BugWatchObjectBuilder

@synthesize parser;

#pragma mark Instantiation and initialization

+ (id)builderWithParser:(LighthouseApiParser *)aParser
{
    return [[[[self class] alloc] initWithParser:aParser] autorelease];
}

- (id)initWithParser:(LighthouseApiParser *)aParser
{
    if (self = [super init])
        self.parser = aParser;

    return self;
}

#pragma mark Building objects

- (NSArray *)parseErrors:(NSData *)xml
{
    parser.className = @"NSString";
    parser.classElementType = @"error";
    parser.classElementCollection = @"errors";
    parser.attributeMappings = nil;

    return [parser parse:xml];
}

- (NSArray *)parseTickets:(NSData *)xml
{
    parser.className = @"Ticket";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"description", @"title",
            @"creationDate", @"created-at", nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketMetaData:(NSData *)xml
{
    parser.className = @"TicketMetaData";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"tags", @"tag",
            @"state", @"state",
            @"lastModifiedDate", @"updated-at", nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketNumbers:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"number", nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketUrls:(NSData *)xml
{
    parser.className = @"NSString";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"string", @"url", nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketMilestoneIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"milestone-id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketProjectIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"project-id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketComments:(NSData *)xml
{
    parser.className = @"TicketComment";
    parser.classElementType = @"version";
    parser.classElementCollection = @"versions";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"date", @"created-at",
            @"text", @"body",
            @"stateChangeDescription", @"diffable-attributes",
            nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketCommentAuthors:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"version";
    parser.classElementCollection = @"versions";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"creator-id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseUserIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"user-id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseCreatorIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"creator-id", nil];

    return [parser parse:xml];
}

@end
