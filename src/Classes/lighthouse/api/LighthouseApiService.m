//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiService.h"
#import "LighthouseApi.h"
#import "LighthouseApiParser.h"

@interface LighthouseApiService ()

- (void)notifyDelegate:(SEL)selector;
- (void)notifyDelegate:(SEL)selector withObject:(id)obj;
- (void)notifyDelegate:(SEL)selector withObject:(id)obj1 withObject:(id)obj2;

- (NSArray *)parseTickets:(NSData *)xml;
- (NSArray *)parseTicketMetaData:(NSData *)xml;
- (NSArray *)parseTicketNumbers:(NSData *)xml;
- (NSArray *)parseMilestoneIds:(NSData *)xml;
- (NSArray *)parseUserIds:(NSData *)xml;
- (NSArray *)parseCreatorIds:(NSData *)xml;
- (NSArray *)parseMilestones:(NSData *)xml;
- (NSArray *)parseTicketBins:(NSData *)xml;

- (BOOL)invokeSelector:(SEL)selector withTarget:(id)target args:(NSArray *)args;

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

#pragma mark Tickets

- (void)fetchTicketsForAllProjects:(NSString *)token
{
    [api fetchTicketsForAllProjects:token];
}

- (void)searchTicketsForAllProjects:(NSString *)searchString
                              token:(NSString *)token
{
    [api searchTicketsForAllProjects:searchString token:token];
}

#pragma mark Ticket bins

- (void)fetchTicketBins:(NSString *)token
{
    [api fetchTicketBinsForProject:27400 token:token];
}

#pragma mark Milestones

- (void)fetchMilestonesForAllProjects:(NSString *)token
{
    [api fetchMilestonesForAllProjects:token];
}

#pragma mark LighthouseApiDelegate implementation

- (void)tickets:(NSData *)data
    fetchedForAllProjectsWithToken:(NSString *)token
{
    NSArray * ticketNumbers = [self parseTicketNumbers:data];
    NSArray * tickets = [self parseTickets:data];
    NSArray * metadata = [self parseTicketMetaData:data];
    NSArray * milestoneIds = [self parseMilestoneIds:data];
    NSArray * userIds = [self parseUserIds:data];
    NSArray * creatorIds = [self parseCreatorIds:data];

    SEL sel =
        @selector(tickets:fetchedForAllProjectsWithMetadata:ticketNumbers:\
             milestoneIds:userIds:creatorIds:);
    if ([delegate respondsToSelector:sel])
        [delegate tickets:tickets fetchedForAllProjectsWithMetadata:metadata
            ticketNumbers:ticketNumbers milestoneIds:milestoneIds
            userIds:userIds creatorIds:creatorIds];
}

- (void)failedToFetchTicketsForAllProjects:(NSString *)token
                                     error:(NSError *)error
{
    SEL sel = @selector(failedToFetchTicketsForAllProjects:);
    if ([delegate respondsToSelector:sel])
        [delegate failedToFetchTicketsForAllProjects:error];
}

- (void)searchResults:(NSData *)data
    fetchedForAllProjectsWithSearchString:(NSString *)searchString
    token:(NSString *)token
{
    NSArray * ticketNumbers = [self parseTicketNumbers:data];
    NSArray * tickets = [self parseTickets:data];
    NSArray * metadata = [self parseTicketMetaData:data];
    NSArray * milestoneIds = [self parseMilestoneIds:data];
    NSArray * userIds = [self parseUserIds:data];
    NSArray * creatorIds = [self parseCreatorIds:data];

    SEL sel = @selector(tickets:fetchedForSearchString:metadata:ticketNumbers:\
        milestoneIds:userIds:creatorIds:);

    [self invokeSelector:sel withTarget:delegate
        args:[NSArray arrayWithObjects:tickets, searchString, metadata,
        ticketNumbers, milestoneIds, userIds, creatorIds, nil]];
}

- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    token:(NSString *)token error:(NSError *)error
{
    SEL sel = @selector(failedToSearchTicketsForAllProjects:error:);
    [self invokeSelector:sel withTarget:delegate
        args:[NSArray arrayWithObjects:searchString, error, nil]];
}

#pragma mark -- Ticket bins

- (void)ticketBins:(NSData *)xml
    fetchedForProject:(NSUInteger)projectId token:(NSString *)token
{
    NSArray * ticketBins = [self parseTicketBins:xml];

    SEL sel = @selector(fetchedTicketBins:token:);
    [self invokeSelector:sel withTarget:delegate
        args:[NSArray arrayWithObjects:ticketBins, token, nil]];
}

- (void)failedToFetchTicketBinsForProject:(NSUInteger)projectId
    token:(NSString *)token error:(NSError *)error
{
    SEL sel = @selector(failedToFetchTicketBins:error:);
    [self invokeSelector:sel withTarget:delegate
        args:[NSArray arrayWithObjects:token, error, nil]];
}

#pragma mark -- Milestones

- (void)milestones:(NSData *)data
    fetchedForAllProjectsWithToken:(NSString *)token
{
    NSArray * milestones = [self parseMilestones:data];

    SEL sel = @selector(milestonesFetchedForAllProjects:);
    if ([delegate respondsToSelector:sel])
        [delegate milestonesFetchedForAllProjects:milestones];
}

- (void)failedToFetchMilestonesForAllProjects:(NSString *)token
                                        error:(NSError *)error
{
    [delegate failedToFetchMilestonesForAllProjects:error];
}

#pragma mark Helper functions for invoking delegate methods

- (void)notifyDelegate:(SEL)selector
{
    if ([delegate respondsToSelector:selector])
        [delegate performSelector:selector];
}

- (void)notifyDelegate:(SEL)selector withObject:(id)obj
{
    if ([delegate respondsToSelector:selector])
        [delegate performSelector:selector withObject:obj];
}

- (void)notifyDelegate:(SEL)selector withObject:(id)obj1 withObject:(id)obj2
{
    if ([delegate respondsToSelector:selector])
        [delegate performSelector:selector withObject:obj1 withObject:obj2];
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

- (NSArray *)parseMilestoneIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"ticket";
    parser.classElementCollection = @"tickets";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"milestone-id", nil];

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

- (NSArray *)parseMilestones:(NSData *)xml
{
    parser.className = @"Milestone";
    parser.classElementType = @"milestone";
    parser.classElementCollection = @"milestones";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"name", @"title",
            @"dueDate", @"due-on",
            @"numOpenTickets", @"open-tickets-count",
            @"numTickets", @"tickets-count",
            @"goals", @"goals",
            nil];

    return [parser parse:xml];
}

- (NSArray *)parseTicketBins:(NSData *)xml
{
    parser.className = @"TicketBin";
    parser.classElementType = @"ticket-bin";
    parser.classElementCollection = @"ticket-bins";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"name", @"name",
            @"searchString", @"query",
            @"ticketCount", @"tickets-count",
            nil];

    return [parser parse:xml];
}

#pragma mark Delegate helpers

- (BOOL)invokeSelector:(SEL)selector withTarget:(id)target args:(NSArray *)args
{
    if ([target respondsToSelector:selector]) {
        NSMethodSignature * sig = [target methodSignatureForSelector:selector];
        NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setTarget:target];
        [inv setSelector:selector];

        for (NSInteger i = 0, count = args.count; i < count; ++i) {
            id arg = [args objectAtIndex:i];
            [inv setArgument:&arg atIndex:i + 2];
        }

        [inv invoke];

        return YES;
    }

    return NO;
}

@end
