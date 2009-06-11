//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiService.h"
#import "LighthouseApi.h"
#import "LighthouseApiParser.h"

#import "BugWatchObjectBuilder.h"
#import "ResponseProcessors.h"
#import "CreateTicketResponseProcessor.h"
#import "EditTicketResponseProcessor.h"

@interface LighthouseApiService ()

- (void)trackProcessor:(ResponseProcessor *)processor forRequest:(id)requestId;
- (void)processResponse:(NSData *)xml toRequest:(id)requestId;
- (void)processErrorResponse:(NSError *)error toRequest:(id)requestId;

@end

@implementation LighthouseApiService

@synthesize delegate;

- (void)dealloc
{
    [api release];

    [builder release];

    [responseProcessors release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString
{
    if (self = [super init]) {
        api = [[LighthouseApi alloc] initWithBaseUrlString:aBaseUrlString];
        api.delegate = self;

        LighthouseApiParser * parser = [LighthouseApiParser parser];
        builder = [[BugWatchObjectBuilder alloc] initWithParser:parser];

        responseProcessors = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Tickets -- searching

- (void)fetchTicketsForAllProjects:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchAllTicketsResponseProcessor processorWithBuilder:builder
                                                      delegate:delegate];

    id requestId = [api fetchTicketsForAllProjects:token];

    [self trackProcessor:processor forRequest:requestId];
}

- (void)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchTicketDetailsResponseProcessor processorWithBuilder:builder
                                                        ticketKey:ticketKey
                                                       projectKey:projectKey
                                                         delegate:delegate];

    id requestId = [api fetchDetailsForTicket:ticketKey
                                    inProject:projectKey
                                        token:token];

    [self trackProcessor:processor forRequest:requestId];
}

- (void)searchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token
{
    ResponseProcessor * processor =
        [SearchAllTicketsResponseProcessor processorWithBuilder:builder
                                                   searchString:searchString
                                                           page:page
                                                       delegate:delegate];

    id requestId =
        [api searchTicketsForAllProjects:searchString page:page token:token];

    [self trackProcessor:processor forRequest:requestId];
}

- (void)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token
{
    ResponseProcessor * processor =
        [SearchAllTicketsResponseProcessor processorWithBuilder:builder
                                                     projectKey:projectKey
                                                   searchString:searchString
                                                           page:page
                                                         object:object
                                                       delegate:delegate];

    id requestId = [api searchTicketsForProject:projectKey
        withSearchString:searchString page:page object:object token:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Tickets -- creating

- (void)createNewTicket:(NewTicketDescription *)desc forProject:(id)projectKey
    token:(NSString *)token
{
    ResponseProcessor * processor =
        [CreateTicketResponseProcessor processorWithBuilder:builder
                                                description:desc
                                                 projectKey:projectKey
                                                   delegate:delegate];

    NSString * creationXml = [desc xmlDescriptionForProject:projectKey];
    id requestId = [api createTicketForProject:projectKey
                                   description:creationXml
                                         token:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Tickets -- editing

- (void)editTicket:(id)ticketKey forProject:(id)projectKey
    withDescription:(UpdateTicketDescription *)desc token:(NSString *)token
{
    ResponseProcessor * processor =
        [EditTicketResponseProcessor processorWithBuilder:builder
                                                ticketKey:ticketKey
                                               projectKey:projectKey
                                              description:desc
                                                 delegate:delegate];

    NSString * xmlDescription = [desc xmlDescriptionForProject:projectKey];
    id requestId = [api editTicket:ticketKey
                        forProject:projectKey
                       description:xmlDescription
                             token:token];

    [self trackProcessor:processor forRequest:requestId];
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

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Ticket bins

- (void)fetchTicketBinsForProject:(id)projectKey token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchTicketBinsResponseProcessor processorWithBuilder:builder
                                                    projectKey:projectKey
                                                      delegate:delegate];

    id requestId = [api fetchTicketBinsForProject:projectKey token:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Users

- (void)fetchAllUsersForProject:(id)projectKey token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchUsersResponseProcessor processorWithBuilder:builder
                                               projectKey:projectKey
                                                 delegate:delegate];

    id requestId = [api fetchAllUsersForProject:projectKey token:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Projects

- (void)fetchAllProjects:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchProjectsResponseProcessor processorWithBuilder:builder
                                                    delegate:delegate];

    id requestId = [api fetchAllProjects:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Milestones

- (void)fetchMilestonesForAllProjects:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchMilestonesResponseProcessor processorWithBuilder:builder
                                                      delegate:delegate];

    id requestId = [api fetchMilestonesForAllProjects:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Messages

- (void)fetchMessagesForProject:(id)projectKey token:(NSString *)token
{
    ResponseProcessor * processor =
        [FetchMessagesResponseProcessor processorWithBuilder:builder
                                                  projectKey:projectKey
                                                    delegate:delegate];

    id requestId = [api fetchMessagesForProject:projectKey token:token];

    [self trackProcessor:processor forRequest:requestId];
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

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Messages -- creating

- (void)createMessage:(NewMessageDescription *)desc forProject:(id)projectKey
    token:(NSString *)token
{
    ResponseProcessor * processor =
        [CreateMessageResponseProcessor processorWithBuilder:builder
                                                  projectKey:projectKey
                                                 description:desc
                                                    delegate:delegate];

    id requestId = [api createMessageForProject:projectKey
                                    description:[desc xmlDescription]
                                          token:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Messages -- editing

- (void)editMessage:(id)messageKey forProject:(id)projectKey
    withDescription:(UpdateMessageDescription *)desc token:(NSString *)token
{
    ResponseProcessor * processor =
        [EditMessageResponseProcessor processorWithBuilder:builder
                                                messageKey:messageKey
                                                projectKey:projectKey
                                               description:desc
                                                  delegate:delegate];

    id requestId = [api editMessage:messageKey forProject:projectKey
         description:[desc xmlDescription] token:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark Messages -- adding comments

- (void)addComment:(NewMessageCommentDescription *)desc toMessage:(id)messageKey
    forProject:(id)projectKey token:(NSString *)token
{
    ResponseProcessor * processor =
        [AddMessageCommentResponseProcessor processorWithBuilder:builder
                                                      messageKey:messageKey
                                                      projectKey:projectKey
                                                     description:desc
                                                        delegate:delegate];

    id requestId = [api addComment:[desc xmlDescription] toMessage:messageKey
        forProject:projectKey token:token];

    [self trackProcessor:processor forRequest:requestId];
}

#pragma mark LighthouseApiDelegate implementation

- (void)request:(id)requestId succeededWithResponse:(NSData *)response
{
    [self processResponse:response toRequest:requestId];
}

- (void)request:(id)requestId failedWithError:(NSError *)error
{
    [self processErrorResponse:error toRequest:requestId];
}

#pragma mark Response processing helpers

- (void)trackProcessor:(ResponseProcessor *)processor forRequest:(id)requestId
{
    NSAssert2([responseProcessors objectForKey:requestId] == nil,
        @"Expected processor for request '%@' to be nil, but is: '%@'.",
        requestId, [responseProcessors objectForKey:requestId]);

    [responseProcessors setObject:processor forKey:requestId];
}

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

@end
