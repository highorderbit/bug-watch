//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiService.h"
#import "LighthouseApi.h"
#import "LighthouseApiParser.h"

@interface LighthouseApiService ()

- (NSArray *)parseTickets:(NSData *)xml;
- (NSArray *)parseTicketMetaData:(NSData *)xml;
- (NSArray *)parseTicketNumbers:(NSData *)xml;
- (NSArray *)parseTicketMilestoneIds:(NSData *)xml;
- (NSArray *)parseUserIds:(NSData *)xml;
- (NSArray *)parseCreatorIds:(NSData *)xml;
- (NSArray *)parseMilestones:(NSData *)xml;
- (NSArray *)parseMilestoneIds:(NSData *)xml;
- (NSArray *)parseMilestoneProjectIds:(NSData *)xml;
- (NSArray *)parseTicketBins:(NSData *)xml;

- (BOOL)invokeSelector:(SEL)selector withTarget:(id)target
    args:(id)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

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

- (void)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString object:(id)object
    token:(NSString *)token
{
    [api searchTicketsForProject:projectKey withSearchString:searchString
        object:object token:token];
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
    NSArray * milestoneIds = [self parseTicketMilestoneIds:data];
    NSArray * userIds = [self parseUserIds:data];
    NSArray * creatorIds = [self parseCreatorIds:data];

    SEL sel =
        @selector(tickets:fetchedForAllProjectsWithMetadata:ticketNumbers:\
             milestoneIds:userIds:creatorIds:);

    [self invokeSelector:sel withTarget:delegate args:tickets, metadata,
        ticketNumbers, milestoneIds, userIds, creatorIds, nil];
}

- (void)failedToFetchTicketsForAllProjects:(NSString *)token
                                     error:(NSError *)error
{
    SEL sel = @selector(failedToFetchTicketsForAllProjects:);
    [self invokeSelector:sel withTarget:delegate args:error, nil];
}

- (void)searchResults:(NSData *)data
    fetchedForAllProjectsWithSearchString:(NSString *)searchString
    token:(NSString *)token
{
    NSArray * ticketNumbers = [self parseTicketNumbers:data];
    NSArray * tickets = [self parseTickets:data];
    NSArray * metadata = [self parseTicketMetaData:data];
    NSArray * milestoneIds = [self parseTicketMilestoneIds:data];
    NSArray * userIds = [self parseUserIds:data];
    NSArray * creatorIds = [self parseCreatorIds:data];

    SEL sel = @selector(tickets:fetchedForSearchString:metadata:ticketNumbers:\
        milestoneIds:userIds:creatorIds:);

    [self invokeSelector:sel withTarget:delegate
        args:tickets, searchString, metadata, ticketNumbers, milestoneIds,
        userIds, creatorIds, nil];
}

- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    token:(NSString *)token error:(NSError *)error
{
    SEL sel = @selector(failedToSearchTicketsForAllProjects:error:);
    [self invokeSelector:sel withTarget:delegate args:searchString, error, nil];
}

- (void)searchResults:(NSData *)data fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString object:(id)object
    token:(NSString *)token
{
    NSArray * ticketNumbers = [self parseTicketNumbers:data];
    NSArray * tickets = [self parseTickets:data];
    NSArray * metadata = [self parseTicketMetaData:data];
    NSArray * milestoneIds = [self parseTicketMilestoneIds:data];
    NSArray * userIds = [self parseUserIds:data];
    NSArray * creatorIds = [self parseCreatorIds:data];

    // call delegate method manually since object might be nil
    SEL sel = @selector(tickets:fetchedForProject:searchString:object:\
        metadata:ticketNumbers:milestoneIds:userIds:creatorIds:);
    if ([delegate respondsToSelector:sel])
        [delegate tickets:tickets fetchedForProject:projectKey
            searchString:searchString object:object metadata:metadata
            ticketNumbers:ticketNumbers milestoneIds:milestoneIds
            userIds:userIds creatorIds:creatorIds];
}

- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString object:(id)object
    token:(NSString *)token error:(NSError *)error
{
    SEL sel =
        @selector(failedToSearchTicketsForProject:searchString:object:error:);
    if ([delegate respondsToSelector:sel])
        [delegate failedToSearchTicketsForProject:projectKey
            searchString:searchString object:object error:error];
}

#pragma mark -- Ticket bins

- (void)ticketBins:(NSData *)xml
    fetchedForProject:(NSUInteger)projectId token:(NSString *)token
{
    NSArray * ticketBins = [self parseTicketBins:xml];

    SEL sel = @selector(fetchedTicketBins:token:);
    [self invokeSelector:sel withTarget:delegate args:ticketBins, token, nil];
}

- (void)failedToFetchTicketBinsForProject:(NSUInteger)projectId
    token:(NSString *)token error:(NSError *)error
{
    SEL sel = @selector(failedToFetchTicketBins:error:);
    [self invokeSelector:sel withTarget:delegate args:token, error, nil];
}

#pragma mark -- Milestones

- (void)milestones:(NSData *)data
    fetchedForAllProjectsWithToken:(NSString *)token
{
    NSArray * milestones = [self parseMilestones:data];
    NSArray * milestoneIds = [self parseMilestoneIds:data];
    NSArray * projectIds = [self parseMilestoneProjectIds:data];

    SEL sel =
        @selector(milestonesFetchedForAllProjects:milestoneIds:projectIds:);
    [self invokeSelector:sel withTarget:delegate args:milestones, milestoneIds,
       projectIds, nil];
}

- (void)failedToFetchMilestonesForAllProjects:(NSString *)token
                                        error:(NSError *)error
{
    SEL sel = @selector(failedToFetchMilestonesForAllProjects:);
    [self invokeSelector:sel withTarget:delegate args:error, nil];
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

- (NSArray *)parseMilestoneIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"milestone";
    parser.classElementCollection = @"milestones";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseMilestoneProjectIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"milestone";
    parser.classElementCollection = @"milestones";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"project-id", nil];

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

- (BOOL)invokeSelector:(SEL)selector withTarget:(id)target
    args:(id)firstArg, ...
{
    if ([target respondsToSelector:selector]) {
        NSMethodSignature * sig = [target methodSignatureForSelector:selector];
        NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setTarget:target];
        [inv setSelector:selector];

        va_list args;
        va_start(args, firstArg);
        NSInteger argIdx = 2;

        for (id arg = firstArg; arg != nil; arg = va_arg(args, id), ++argIdx)
            [inv setArgument:&arg atIndex:argIdx];

        [inv invoke];

        return YES;
    }

    return NO;
}

@end
