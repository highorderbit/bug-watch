//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "GTMSenTestCase.h"
#import "LighthouseApiParser.h"
#import "NSDate+LighthouseStringHelpers.h"

#import "Milestone.h"
#import "Ticket.h"
#import "TicketMetaData.h"

@interface LighthouseApiParserTest : GTMTestCase
{
    LighthouseApiParser * parser;
}

+ (NSData *)loadXmlFileNamed:(NSString *)fileName;

+ (NSDictionary *)milestoneMappings;
+ (NSDictionary *)ticketMappings;
+ (NSDictionary *)ticketMetaDataMappings;

@end

@implementation LighthouseApiParserTest

- (void)setUp
{
    parser = [[LighthouseApiParser alloc] init];
}

- (void)tearDown
{
    [parser release];
    parser = nil;
}

- (void)testMilestoneParsing
{
    NSData * xml = [[self class] loadXmlFileNamed:@"milestone"];

    parser.className = @"Milestone";
    parser.classElementType = @"milestone";
    parser.attributeMappings = [[self class] milestoneMappings];
    parser.classElementCollection = nil;
    Milestone * milestone = [parser parse:xml];

    STAssertEqualStrings(@"1.0.0", milestone.name,
        @"Milestone name parsed incorrectly.");
    // use subtraction to avoid type mismatch errors from STAssertEquals
    STAssertTrue(
        milestone.numOpenTickets - 3 == 0,
        @"Milestone open tickets parsed incorrectly.");
    STAssertTrue(
        milestone.numTickets - 26 == 0,
        @"Milestone ticket count parsed incorrectly.");
    STAssertEqualObjects(
        [NSDate dateWithLighthouseString:@"2009-04-19T00:00:00-06:00"],
        milestone.dueDate,
        @"Milestone due date parsed incorrectly.");
}

- (void)testTicketParsing
{
    NSData * xml = [[self class] loadXmlFileNamed:@"ticket"];

    parser.className = @"Ticket";
    parser.classElementType = @"ticket";
    parser.attributeMappings = [[self class] ticketMappings];
    parser.classElementCollection = nil;
    Ticket * ticket = [parser parse:xml];

    STAssertEqualStrings(
        @"Keypad \"done\" button incorrectly enabled on log in and "
        "favorites",
        ticket.description,
        @"Ticket description parsed incorrectly.");
    STAssertEqualObjects(
        [NSDate dateWithLighthouseString:@"2009-04-22T10:05:25-06:00"],
        ticket.creationDate,
        @"Ticket creation date parsed incorrectly.");
}

- (void)testTicketMetaDataParsing
{
    NSData * xml = [[self class] loadXmlFileNamed:@"ticket"];

    parser.className = @"TicketMetaData";
    parser.classElementType = @"ticket";
    parser.attributeMappings = [[self class] ticketMetaDataMappings];
    TicketMetaData * tmd = [parser parse:xml];

    STAssertEqualStrings(
        @"bug loginview", tmd.tags, @"Failed to parse ticket tags correctly.");
    STAssertEqualObjects(
        [NSDate dateWithLighthouseString:@"2009-05-01T18:19:55-06:00"],
        tmd.lastModifiedDate,
        @"Failed to parse ticket modified date correctly.");
}

- (void)testTicketsParsing
{
    NSData * xml = [[self class] loadXmlFileNamed:@"tickets"];

    parser.className = @"Ticket";
    parser.classElementType = @"ticket";
    parser.attributeMappings = [[self class] ticketMappings];
    parser.classElementCollection = @"tickets";

    NSArray * tickets = [parser parse:xml];

    STAssertEqualObjects(
        [NSNumber numberWithInteger:30],
        [NSNumber numberWithInteger:tickets.count],
        @"Parsed incorrect number of elements.");
}

- (void)testNSNumberParsing
{
    NSData * xml = [[self class] loadXmlFileNamed:@"milestones"];

    parser.className = @"NSNumber";
    parser.classElementType = @"milestone";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:@"number", @"id", nil];
    parser.classElementCollection = @"milestones";

    NSArray * numbers = [parser parse:xml];

    NSArray * expected =
        [NSArray arrayWithObjects:
        [NSNumber numberWithInteger:37266],
        [NSNumber numberWithInteger:37670],
        [NSNumber numberWithInteger:38302],
        [NSNumber numberWithInteger:38299],
        [NSNumber numberWithInteger:38804],
        nil];

    STAssertTrue(
        [numbers isEqualToArray:expected] == YES,
        @"Parsed numbers incorrectly.");
}

- (void)testEmptySearchResults
{
    NSData * xml = [[self class] loadXmlFileNamed:@"empty-search-result"];

    parser.className = @"NSNumber";
    parser.classElementType = @"ticket";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:@"number", @"number", nil];
    parser.classElementCollection = @"tickets";

    NSArray * tickets = [parser parse:xml];

    STAssertNotNil(tickets, @"Tickets are nil.");
    STAssertTrue(tickets.count == 0, @"Ticket count is %d; should be 0.",
        tickets.count);
}

+ (NSData *)ticketXml
{
    return [[self class] loadXmlFileNamed:@"ticket"];
}

+ (NSData *)ticketsXml
{
    return [[self class] loadXmlFileNamed:@"tickets"];
}

+ (NSData *)loadXmlFileNamed:(NSString *)fileName
{
    NSString * path =
        [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];  
    return [NSData dataWithContentsOfFile:path];
}

+ (NSDictionary *)milestoneMappings
{
    return
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"name", @"title",
            @"dueDate", @"due-on",
            @"numOpenTickets", @"open-tickets-count",
            @"numTickets", @"tickets-count", nil];
}

+ (NSDictionary *)ticketMappings
{
    return
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"description", @"title",
            @"creationDate", @"created-at", nil];
}

+ (NSDictionary *)ticketMetaDataMappings
{
    return
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"tags", @"tag",
            @"state", @"state",
            @"lastModifiedDate", @"updated-at", nil];
}

@end
