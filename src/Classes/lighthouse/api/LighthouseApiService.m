//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiService.h"
#import "LighthouseApi.h"
#import "LighthouseApiParser.h"

@interface LighthouseApiService ()

- (NSArray *)parseTickets:(NSData *)xml;
- (NSArray *)parseTicketMetaData:(NSData *)xml;

@end

@implementation LighthouseApiService

@synthesize delegate;

- (void)dealloc
{
    [api release];
    [parser release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString
{
    if (self = [super init]) {
        api = [[LighthouseApi alloc] initWithBaseUrlString:aBaseUrlString];
        api.delegate = self;

        parser = [[LighthouseApiParser alloc] init];
    }

    return self;
}

#pragma mark Fetching tickets

- (void)fetchTicketsForAllProjects:(NSString *)token
{
    [api fetchTicketsForAllProjects:token];
}

#pragma mark LighthouseApiDelegate implementation

- (void)tickets:(NSData *)data fetchedForAllProjects:(NSString *)token
{
    NSArray * tickets = [self parseTickets:data];
    NSArray * metadata = [self parseTicketMetaData:data];

    [delegate tickets:tickets fetchedForAllProjectsWithMetadata:metadata];
}

- (void)failedToFetchTicketsForAllProjects:(NSString *)token
                                     error:(NSError *)error
{
    [delegate failedToFetchTicketsForAllProjects:error];
}

#pragma mark Parsing XML

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

@end
