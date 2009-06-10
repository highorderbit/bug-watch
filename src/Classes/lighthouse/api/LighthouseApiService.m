//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiService.h"
#import "LighthouseApi.h"
#import "LighthouseApiParser.h"
#import "RandomNumber.h"
#import "RegexKitLite.h"

#import "BugWatchObjectBuilder.h"

#import "ResponseProcessors.h"
#import "CreateTicketResponseProcessor.h"
#import "EditTicketResponseProcessor.h"

@interface LighthouseApiService ()

- (NSArray *)parseTickets:(NSData *)xml;
- (NSArray *)parseTicketMetaData:(NSData *)xml;
- (NSArray *)parseTicketNumbers:(NSData *)xml;
- (NSArray *)parseTicketMilestoneIds:(NSData *)xml;
- (NSArray *)parseTicketProjectIds:(NSData *)xml;

- (NSArray *)parseProjects:(NSData *)xml;
- (NSArray *)parseProjectKeys:(NSData *)xml;

- (NSArray *)parseUsers:(NSData *)xml;
- (NSArray *)parseUserKeys:(NSData *)xml;
- (NSArray *)parseUserIds:(NSData *)xml;

- (NSArray *)parseCreatorIds:(NSData *)xml;

- (NSArray *)parseTicketComments:(NSData *)xml;
- (NSArray *)parseTicketCommentAuthors:(NSData *)xml;
- (NSArray *)parseTicketUrls:(NSData *)xml;

- (NSArray *)parseMilestones:(NSData *)xml;
- (NSArray *)parseMilestoneIds:(NSData *)xml;
- (NSArray *)parseMilestoneProjectIds:(NSData *)xml;

- (NSArray *)parseMessages:(NSData *)xml;
- (NSArray *)parseMessageKeys:(NSData *)xml;
- (NSArray *)parseMessageAuthorKeys:(NSData *)xml;
- (NSArray *)parseMessageCommentKeys:(NSData *)xml;
- (NSArray *)parseMessageComments:(NSData *)xml;
- (NSArray *)parseMessageCommentAuthorIds:(NSData *)xml;

- (NSArray *)parseTicketBins:(NSData *)xml;

- (BOOL)invokeSelector:(SEL)selector withTarget:(id)target
    args:(id)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

- (void)processResponse:(NSData *)xml toRequest:(id)requestId;
- (void)processErrorResponse:(NSError *)error toRequest:(id)requestId;

+ (id)nextRequestId;

@end

@implementation LighthouseApiService

@synthesize delegate;

- (void)dealloc
{
    [api release];

    [parser release];
    [builder release];

    [changeTicketRequests release];
    [responseProcessors release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString
{
    if (self = [super init]) {
        api = [[LighthouseApi alloc] initWithBaseUrlString:aBaseUrlString];
        api.delegate = self;

        parser = [[LighthouseApiParser alloc] init];
        builder = [[BugWatchObjectBuilder alloc] initWithParser:parser];

        changeTicketRequests = [[NSMutableDictionary alloc] init];
        responseProcessors = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Tickets -- searching

- (void)fetchTicketsForAllProjects:(NSString *)token
{
    FetchAllTicketsResponseProcessor * processor =
        [FetchAllTicketsResponseProcessor processorWithBuilder:builder
                                                      delegate:delegate];

    id requestId = [api fetchTicketsForAllProjects:token];

    [responseProcessors setObject:processor forKey:requestId];
}

- (void)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token
{
    FetchTicketDetailsResponseProcessor * processor =
        [FetchTicketDetailsResponseProcessor processorWithBuilder:builder
                                                        ticketKey:ticketKey
                                                       projectKey:projectKey
                                                         delegate:delegate];

    id requestId = [api fetchDetailsForTicket:ticketKey
                                    inProject:projectKey
                                        token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

- (void)searchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token
{
    SearchAllTicketsResponseProcessor * processor =
        [SearchAllTicketsResponseProcessor processorWithBuilder:builder
                                                   searchString:searchString
                                                           page:page
                                                       delegate:delegate];

    id requestId =
        [api searchTicketsForAllProjects:searchString page:page token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

- (void)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token
{
    SearchAllTicketsResponseProcessor * processor =
        [SearchAllTicketsResponseProcessor processorWithBuilder:builder
                                                     projectKey:projectKey
                                                   searchString:searchString
                                                           page:page
                                                         object:object
                                                       delegate:delegate];

    id requestId = [api searchTicketsForProject:projectKey
        withSearchString:searchString page:page object:object token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Tickets -- creating

- (void)createNewTicket:(NewTicketDescription *)desc forProject:(id)projectKey
    token:(NSString *)token
{
    CreateTicketResponseProcessor * processor =
        [CreateTicketResponseProcessor processorWithBuilder:builder
                                                description:desc
                                                 projectKey:projectKey
                                                   delegate:delegate];

    NSString * creationXml = [desc xmlDescriptionForProject:projectKey];
    id requestId = [api createTicketForProject:projectKey
                                   description:creationXml
                                        object:nil
                                         token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Tickets -- editing

- (void)editTicket:(id)ticketKey forProject:(id)projectKey
    withDescription:(UpdateTicketDescription *)desc token:(NSString *)token
{
    EditTicketResponseProcessor * processor =
        [EditTicketResponseProcessor processorWithBuilder:builder
                                                ticketKey:ticketKey
                                               projectKey:projectKey
                                              description:desc
                                                 delegate:delegate];

    NSString * xmlDescription = [desc xmlDescriptionForProject:projectKey];
    id requestId = [api editTicket:ticketKey
                        forProject:projectKey
                       description:xmlDescription
                            object:nil
                             token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Tickets -- deleting

- (void)deleteTicket:(id)ticketKey forProject:(id)projectKey
    token:(NSString *)token
{
    ResponseProcessor * processor =
        [DeleteTicketResponseProcessor processorWithBuilder:builder
                                                  ticketKey:ticketKey
                                                 projectKey:projectKey
                                                   delegate:delegate];

    id requestId =
        [api deleteTicket:ticketKey forProject:projectKey token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Ticket bins

- (void)fetchTicketBinsForProject:(id)projectKey token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchTicketBinsResponseProcessor processorWithBuilder:builder
                                                    projectKey:projectKey
                                                      delegate:delegate];

    id requestId = [api fetchTicketBinsForProject:projectKey token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Users

- (void)fetchAllUsersForProject:(id)projectKey token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchUsersResponseProcessor processorWithBuilder:builder
                                               projectKey:projectKey
                                                 delegate:delegate];

    id requestId = [api fetchAllUsersForProject:projectKey token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Projects

- (void)fetchAllProjects:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchProjectsResponseProcessor processorWithBuilder:builder
                                                    delegate:delegate];

    id requestId = [api fetchAllProjects:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Milestones

- (void)fetchMilestonesForAllProjects:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchMilestonesResponseProcessor processorWithBuilder:builder
                                                      delegate:delegate];

    id requestId = [api fetchMilestonesForAllProjects:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Messages

- (void)fetchMessagesForProject:(id)projectKey token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchMessagesResponseProcessor processorWithBuilder:builder
                                                  projectKey:projectKey
                                                    delegate:delegate];

    id requestId = [api fetchMessagesForProject:projectKey token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

- (void)fetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchMessageCommentsResponseProcessor
            processorWithBuilder:builder
                      messageKey:messageKey
                      projectKey:projectKey
                        delegate:delegate];

    id requestId = [api fetchCommentsForMessage:messageKey
                                      inProject:projectKey
                                          token:token];

    [responseProcessors setObject:processor forKey:requestId];
}

#pragma mark Messages -- creating

- (void)createMessage:(NewMessageDescription *)desc forProject:(id)projectKey
    token:(NSString *)token
{
    id requestId = [[self class] nextRequestId];
    [changeTicketRequests setObject:[[desc copy] autorelease] forKey:requestId];

    [api createMessageForProject:projectKey description:[desc xmlDescription]
        object:requestId token:token];
}

#pragma mark Messages -- editing

- (void)editMessage:(id)messageKey forProject:(id)projectKey
    withDescription:(UpdateMessageDescription *)desc token:(NSString *)token
{
    id requestId = [[self class] nextRequestId];
    [changeTicketRequests setObject:[[desc copy] autorelease] forKey:requestId];

    [api editMessage:messageKey forProject:projectKey
         description:[desc xmlDescription] object:requestId token:token];
}

#pragma mark Messages -- adding comments

- (void)addComment:(NewMessageCommentDescription *)desc toMessage:(id)messageKey
    forProject:(id)projectKey token:(NSString *)token
{
    id requestId = [[self class] nextRequestId];
    [changeTicketRequests setObject:[[desc copy] autorelease] forKey:requestId];

    [api addComment:[desc xmlDescription] toMessage:messageKey
        forProject:projectKey object:requestId token:token];
}

#pragma mark LighthouseApiDelegate implementation

- (void)tickets:(NSData *)xml fetchedForAllProjectsWithToken:(NSString *)token
    requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchTicketsForAllProjects:(NSString *)token
    requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

- (void)details:(NSData *)xml fetchedForTicket:(id)ticketKey
    inProject:(id)projectKey token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchTicketDetailsForTicket:(id)ticketKey
    inProject:(id)projectKey token:(NSString *)token requestId:(id)requestId
    error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

- (void)searchResults:(NSData *)xml
    fetchedForAllProjectsWithSearchString:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token requestId:(id)requestId
    error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

- (void)searchResults:(NSData *)xml fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token requestId:(id)requestId
    error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark Tickets -- creating

- (void)ticketCreated:(NSData *)xml description:(NSString *)description
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToCreateTicketWithDescription:(NSString *)description
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark Tickets -- editing

- (void)editedTicket:(id)ticketKey forProject:(id)projectKey
    withDescription:(NSString *)description object:(id)object
    response:(NSData *)xml token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToEditTicket:(id)ticketKey forProject:(id)projectKey
    description:(NSString *)desc object:(id)object token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark Tickets -- deleting

- (void)deletedTicket:(id)ticketKey forProject:(id)projectKey
    response:(NSData *)xml token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToDeleteTicket:(id)ticketKey forProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark -- Ticket bins

- (void)ticketBins:(NSData *)xml fetchedForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchTicketBinsForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark -- Users

- (void)allUsers:(NSData *)xml fetchedForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchAllUsersForProject:(id)projectKey token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark -- Projects

- (void)projects:(NSData *)xml fetchedForAllProjects:(NSString *)token
    requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchAllProjects:(NSString *)token requestId:(id)requestId
    error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark -- Milestones

- (void)milestones:(NSData *)xml
    fetchedForAllProjectsWithToken:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchMilestonesForAllProjects:(NSString *)token
    requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark -- Messages

- (void)messages:(NSData *)xml fetchedForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchMessagesForProject:(id)projectKey token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

- (void)comments:(NSData *)xml fetchedForMessage:(id)messageKey
    inProject:(id)projectKey token:(NSString *)token requestId:(id)requestId
{
    [self processResponse:xml toRequest:requestId];
}

- (void)failedToFetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark Messages -- creating

- (void)message:(NSData *)response createdForProject:(id)projectKey
    withDescription:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId
{
    NewMessageDescription * desc =
        [changeTicketRequests objectForKey:requestId];
    NSAssert1(desc, @"Did not find a pending message creation request for key: "
        "%@.", requestId);

    NSArray * keys = [self parseMessageKeys:response];
    NSAssert2(keys.count == 1, @"Expected 1 message ID, but received %d: %@.",
        keys.count, keys);
    id key = [keys lastObject];

    SEL sel = @selector(message:describedBy:createdForProject:);
    [self invokeSelector:sel withTarget:delegate args:key, desc, projectKey,
        nil];

    [changeTicketRequests removeObjectForKey:requestId];
}

- (void)failedToCreateMessageForProject:(id)projectKey
    withDescription:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error
{
    NewMessageDescription * desc =
        [changeTicketRequests objectForKey:requestId];
    NSAssert1(desc, @"Did not find a pending message creation request for key: "
        "%@.", requestId);

    SEL sel = @selector(failedToCreateMessageDescribedBy:forProject:error:);
    [self invokeSelector:sel withTarget:delegate args:desc, projectKey, error,
        nil];

    [changeTicketRequests removeObjectForKey:requestId];
}

#pragma mark Messages -- editing

- (void)editedMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId response:(NSData *)xml
{
    UpdateMessageDescription * desc =
        [changeTicketRequests objectForKey:requestId];
    NSAssert1(desc, @"Did not find a pending update message request for key: "
        "%@.", requestId);

    SEL sel = @selector(editedMessage:forProject:describedBy:);
    [self invokeSelector:sel withTarget:delegate args:messageKey,
        projectKey, desc, nil];

    [changeTicketRequests removeObjectForKey:requestId];
}

- (void)failedToEditMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error
{
    UpdateMessageDescription * desc =
        [changeTicketRequests objectForKey:requestId];
    NSAssert1(desc, @"Did not find a pending update message request for key: "
        "%@.", requestId);

    SEL sel = @selector(failedToEditMessage:forProject:describedBy:error:);
    [self invokeSelector:sel withTarget:delegate args:messageKey,
        projectKey, desc, error, nil];

    [changeTicketRequests removeObjectForKey:requestId];
}

#pragma mark Messages -- adding comments

- (void)addedComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId response:(NSData *)xml
{
    NewMessageCommentDescription * desc =
        [changeTicketRequests objectForKey:requestId];
    NSAssert1(desc, @"Did not find a pending new message comment request for "
        "key: %@.", requestId);

    NSArray * commentKeys = [self parseMessageCommentKeys:xml];
    NSArray * comments = [self parseMessageComments:xml];
    NSArray * authors = [self parseMessageCommentAuthorIds:xml];

    NSAssert3(commentKeys.count == 1 && comments.count == 1 &&
        authors.count == 1, @"Expected 1 new message comment, but got: %@, %@, "
        "%@.", commentKeys, comments, authors);

    SEL sel = @selector(comment:withKey:authorKey:addedToMessage:forProject:\
        describedBy:);
    [self invokeSelector:sel withTarget:delegate args:[comments lastObject],
        [commentKeys lastObject], [authors lastObject], messageKey, projectKey,
        desc, nil];

    [changeTicketRequests removeObjectForKey:requestId];
}

- (void)failedToAddComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error
{
    NewMessageCommentDescription * desc =
        [changeTicketRequests objectForKey:requestId];
    NSAssert1(desc, @"Did not find a pending new message comment request for "
        "key: %@.", requestId);

    SEL sel =
        @selector(failedToAddCommentToMessage:forProject:describedBy:error:);
    [self invokeSelector:sel withTarget:delegate args:messageKey, projectKey,
        desc, error, nil];

    [changeTicketRequests removeObjectForKey:requestId];
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

- (NSArray *)parseProjects:(NSData *)xml
{
    parser.className = @"Project";
    parser.classElementType = @"project";
    parser.classElementCollection = @"projects";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"name", @"name",
            nil];

    return [parser parse:xml];
}

- (NSArray *)parseProjectKeys:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"project";
    parser.classElementCollection = @"projects";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"id",
            nil];

    return [parser parse:xml];
}

- (NSArray *)parseUsers:(NSData *)xml
{
    parser.className = @"User";
    parser.classElementType = @"user";
    parser.classElementCollection = @"memberships";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"name", @"name",
            @"job", @"job",
            @"websiteLink", @"website",
            @"avatarLink", @"avatar-url",
            nil];

    return [parser parse:xml];
}

- (NSArray *)parseUserKeys:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"membership";
    parser.classElementCollection = @"memberships";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"number", @"user-id", nil];

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

- (NSArray *)parseMessages:(NSData *)xml
{
    parser.className = @"Message";
    parser.classElementType = @"message";
    parser.classElementCollection = @"messages";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"title", @"title",
            @"postedDate", @"created-at",
            @"message", @"body",
            nil];

    return [parser parse:xml];
}

- (NSArray *)parseMessageKeys:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"message";
    parser.classElementCollection = @"messages";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseMessageAuthorKeys:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"message";
    parser.classElementCollection = @"messages";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"user-id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseMessageCommentKeys:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"comment";
    parser.classElementCollection = @"comments";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"id", nil];

    return [parser parse:xml];
}

- (NSArray *)parseMessageComments:(NSData *)xml
{
    parser.className = @"MessageResponse";
    parser.classElementType = @"comment";
    parser.classElementCollection = @"comments";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"text", @"body",
            @"date", @"created-at",
            nil];

    return [parser parse:xml];
}

- (NSArray *)parseMessageCommentAuthorIds:(NSData *)xml
{
    parser.className = @"NSNumber";
    parser.classElementType = @"comment";
    parser.classElementCollection = @"comments";
    parser.attributeMappings =
        [NSDictionary dictionaryWithObjectsAndKeys:
            @"", @"user-id", nil];

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

        va_end(args);

        [inv invoke];

        return YES;
    }

    return NO;
}

#pragma mark Response processing helpers

- (void)processResponse:(NSData *)xml toRequest:(id)requestId
{
    ResponseProcessor * processor = [responseProcessors objectForKey:requestId];
    NSAssert1(processor, @"Failed to find a response process for request: "
        "'%@'.", requestId);

    [processor process:xml];
    [responseProcessors removeObjectForKey:requestId];
}

- (void)processErrorResponse:(NSError *)error toRequest:(id)requestId
{
    ResponseProcessor * processor = [responseProcessors objectForKey:requestId];
    NSAssert1(processor, @"Failed to find a response process for request: "
        "'%@'.", requestId);

    [processor processError:error];
    [responseProcessors removeObjectForKey:requestId];
}

#pragma mark Notification names

+ (NSString *)milestonesReceivedForAllProjectsNotificationName
{
    return @"BugWatchMilestonesReceivedNotification";
}

+ (NSString *)usersRecevedForProjectNotificationName
{
    return @"BugWatchUsersReceivedForProjectNotification";
}

+ (NSString *)allProjectsReceivedNotificationName
{
    return @"BugWatchAllProjectsReceivedNotification";
}

#pragma mark General helpers

+ (id)nextRequestId
{
    return [RandomNumber randomNumber];
}

@end
