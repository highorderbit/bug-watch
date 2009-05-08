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

+ (NSString *)milestoneXml;
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

+ (NSString *)milestoneXml
{
    return
        @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
         "<milestone>\n"
         "<created-at type=\"datetime\">2009-04-15T13:48:39-06:00"
         "</created-at>\n"
         "<due-on type=\"datetime\">2009-04-19T00:00:00-06:00</due-on>\n"
         "<goals>First version released to the App Store.</goals>\n"
         "<goals-html>&lt;div&gt;&lt;p&gt;First version released to the App "
         "Store.&lt;/p&gt;&lt;/div&gt;</goals-html>\n"
         "<id type=\"integer\">37266</id>\n"
         "<open-tickets-count type=\"integer\">3</open-tickets-count>\n"
         "<permalink>100</permalink>\n"
         "<project-id type=\"integer\">27400</project-id>\n"
         "<tickets-count type=\"integer\">26</tickets-count>\n"
         "<title>1.0.0</title>\n"
         "<updated-at type=\"datetime\">2009-04-27T12:12:12-06:00"
         "</updated-at>\n"
         "<url>http://highorderbit.lighthouseapp.com/projects/27400/milestones"
         "/37266</url>\n"
         "<user-name nil=\"true\"></user-name>\n"
         "</milestone>";
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
