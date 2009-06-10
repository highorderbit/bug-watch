//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApi.h"
#import "WebServiceApi.h"
#import "WebServiceResponseDispatcher.h"
#import "RandomNumber.h"

@interface LighthouseApi ()

- (void)sendRequestToUrl:(NSString *)urlString callback:(SEL)sel
    object:(id)object;
+ (id)uniqueRequestId;

@end

@implementation LighthouseApi

@synthesize delegate;

- (void)dealloc
{
    [baseUrlString release];

    [api release];
    [dispatcher release];

    [arguments release];

    [super dealloc];
}

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString
{
    if (self = [super init]) {
        baseUrlString = [aBaseUrlString copy];
        api = [[WebServiceApi alloc] initWithDelegate:self];
        dispatcher = [[WebServiceResponseDispatcher alloc] init];

        arguments = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark Tickets

- (id)fetchTicketsForAllProjects:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@tickets.xml?_token=%@", baseUrlString,
        token];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    [arguments setObject:args forKey:requestId];

    SEL sel = @selector(handleTicketsForAllProjectsResponse:toRequest:object:);

    [self sendRequestToUrl:urlString callback:sel object:requestId];

    return requestId;
}

- (id)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets/%@.xml?_token=%@",
        baseUrlString, projectKey, ticketKey, token];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token", projectKey, @"projectKey", ticketKey, @"ticketKey",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel = @selector(handleTicketDetailsResponse:toRequest:object:);

    [self sendRequestToUrl:urlString callback:sel object:requestId];

    return requestId;
}

- (id)searchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@tickets.xml?q=%@&page=%u&_token=%@",
        baseUrlString,
        [searchString
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        page,
        token];
    NSURLRequest * req =
        [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        searchString, @"searchString",
        [NSNumber numberWithInteger:page], @"page",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel =
        @selector(handleTicketSearchResultsForAllProjectsResponse:toRequest:\
            object:);

    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

- (id)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString
            stringWithFormat:
            @"%@projects/%@/tickets.xml?q=%@&page=%u&_token=%@",
        baseUrlString,
        projectKey,
        [searchString
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        page,
        token];
    NSURLRequest * req =
        [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        searchString, @"searchString",
        projectKey, @"projectKey",
        [NSNumber numberWithInteger:page], @"page",
        object ? object : [NSNull null], @"object",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel = @selector(handleTicketSearchResultsResponse:toRequest:object:);
    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

- (id)createTicketForProject:(id)projectKey description:(NSString *)description
    object:(id)object token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets.xml?_token=%@",
        baseUrlString, projectKey, token];
    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        projectKey, @"projectKey",
        description, @"description",
        object ? object : [NSNull null], @"object",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel =
        @selector(handleTicketCreationResponse:toRequest:object:);
    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

#pragma mark Tickets -- editing

- (id)editTicket:(id)ticketKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSAssert(ticketKey, @"Ticket key cannot be nil.");
    NSAssert(projectKey, @"Project key cannot be nil.");
    NSAssert(description, @"Description cannot be nil.");
    NSAssert(token, @"Token cannot be nil.");

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets/%@.xml?_token=%@",
        baseUrlString, projectKey, ticketKey, token];
    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"PUT"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        ticketKey, @"ticketKey",
        projectKey, @"projectKey",
        description, @"description",
        object, @"object",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel = @selector(handleEditTicketResponse:toRequest:object:);
    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

#pragma mark Tickets -- deleting

- (id)deleteTicket:(id)ticketKey forProject:(id)projectKey
    token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets/%@.xml?_token=%@",
        baseUrlString, projectKey, ticketKey, token];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"DELETE"];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        ticketKey, @"ticketKey",
        projectKey, @"projectKey",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel = @selector(handleDeleteTicketResponse:toRequest:object:);
    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

#pragma mark Ticket Bins

- (id)fetchTicketBinsForProject:(id)projectKey token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/bins.xml?_token=%@",
        baseUrlString, projectKey, token];
    SEL sel = @selector(handleTicketBinResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        projectKey, @"projectKey",
        nil];
    [arguments setObject:args forKey:requestId];

    [self sendRequestToUrl:urlString callback:sel object:requestId];

    return requestId;
}

#pragma mark Users

- (id)fetchAllUsersForProject:(id)projectKey token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/memberships.xml?_token=%@",
        baseUrlString, projectKey, token];

    SEL callback =
        @selector(handleAllUsersForProjectResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token", projectKey, @"projectKey", nil];
    [arguments setObject:args forKey:requestId];

    [self sendRequestToUrl:urlString callback:callback object:requestId];

    return requestId;
}

#pragma mark Projects

- (id)fetchAllProjects:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects.xml?_token=%@",
        baseUrlString, token];

    SEL callback =
        @selector(handleAllProjectsResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    [arguments setObject:args forKey:requestId];

    [self sendRequestToUrl:urlString callback:callback object:requestId];

    return requestId;
}

#pragma mark Milestones

- (id)fetchMilestonesForAllProjects:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@milestones.xml?_token=%@", baseUrlString,
        token];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    [arguments setObject:args forKey:requestId];

    SEL sel =
        @selector(handleMilestonesForAllProjectsResponse:toRequest:object:);

    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

#pragma mark Messages

- (id)fetchMessagesForProject:(id)projectKey token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/messages.xml?_token=%@",
        baseUrlString, projectKey, token];

    SEL callback =
        @selector(handleMessagesForProjectResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token", projectKey, @"projectKey", nil];
    [arguments setObject:args forKey:requestId];

    [self sendRequestToUrl:urlString callback:callback object:requestId];

    return requestId;
}

- (id)fetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/messages/%@.xml?_token=%@",
        baseUrlString, projectKey, messageKey, token];

    SEL callback =
        @selector(handleMessageCommentsResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        messageKey, @"messageKey",
        projectKey, @"projectKey",
        token, @"token",
        nil];
    [arguments setObject:args forKey:requestId];

    [self sendRequestToUrl:urlString callback:callback object:requestId];

    return requestId;
}

#pragma mark Messages -- creating

- (id)createMessageForProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/messages.xml?_token=%@",
        baseUrlString, projectKey, token];
    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        projectKey, @"projectKey",
        description, @"description",
        object ? object : [NSNull null], @"object",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel =
        @selector(handleCreateMessageForProjectResponse:toRequest:object:);
    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

#pragma mark Messages -- editing

- (id)editMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/messages/%@.xml?_token=%@",
        baseUrlString, projectKey, messageKey, token];
    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"PUT"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        messageKey, @"messageKey",
        projectKey, @"projectKey",
        description, @"description",
        object ? object : [NSNull null], @"object",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel = @selector(handleEditMessageResponse:toRequest:object:);
    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

#pragma mark Messages -- adding comments

- (id)addComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey object:(id)object token:(NSString *)token
{
    id requestId = [[self class] uniqueRequestId];

    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/messages/%@/comments.xml?"
        "_token=%@", baseUrlString, projectKey, messageKey, token];
    NSData * encodedDescription =
        [comment dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        messageKey, @"messageKey",
        projectKey, @"projectKey",
        comment, @"comment",
        object ? object : [NSNull null], @"object",
        nil];
    [arguments setObject:args forKey:requestId];

    SEL sel = @selector(handleAddMessageCommentResponse:toRequest:object:);
    [dispatcher
        request:req isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:req];

    return requestId;
}

#pragma mark Handling responses

- (void)handleTicketsForAllProjectsResponse:(id)response
                                  toRequest:(NSURLRequest *)request
                                     object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchTicketsForAllProjects:token requestId:requestId
            error:response];
    else
        [delegate tickets:response fetchedForAllProjectsWithToken:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleTicketDetailsResponse:(id)response
                          toRequest:(NSURLRequest *)request
                             object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];
    id ticketKey = [args objectForKey:@"ticketKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchTicketDetailsForTicket:ticketKey
            inProject:projectKey token:token requestId:requestId
            error:response];
    else
        [delegate details:response fetchedForTicket:ticketKey
            inProject:projectKey token:token requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleMilestonesForAllProjectsResponse:(id)response
                                     toRequest:(NSURLRequest *)request
                                        object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchMilestonesForAllProjects:token
            requestId:requestId error:response];
    else
        [delegate milestones:response fetchedForAllProjectsWithToken:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleMessagesForProjectResponse:(id)response
                               toRequest:(NSURLRequest *)request
                                  object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchMessagesForProject:projectKey token:token
            requestId:requestId error:response];
    else
        [delegate messages:response fetchedForProject:projectKey token:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleMessageCommentsResponse:(id)response
                            toRequest:(NSURLRequest *)request
                               object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];
    id messageKey = [args objectForKey:@"messageKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchCommentsForMessage:messageKey
            inProject:projectKey token:token requestId:requestId
            error:response];
    else
        [delegate comments:response fetchedForMessage:messageKey
            inProject:projectKey token:token requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleCreateMessageForProjectResponse:(id)response
                                    toRequest:(NSURLRequest *)request
                                       object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];
    NSString * description = [args objectForKey:@"description"];
    id object = [args objectForKey:@"object"];
    object = [object isEqual:[NSNull null]] ? nil : object;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToCreateMessageForProject:projectKey
            withDescription:description object:object token:token
            requestId:requestId error:response];
    else
        [delegate message:response createdForProject:projectKey
            withDescription:description object:object token:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleEditMessageResponse:(id)response
                        toRequest:(NSURLRequest *)request
                           object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id messageKey = [args objectForKey:@"messageKey"];
    id projectKey = [args objectForKey:@"projectKey"];
    NSString * description = [args objectForKey:@"description"];
    id object = [args objectForKey:@"object"];
    object = [object isEqual:[NSNull null]] ? nil : object;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToEditMessage:messageKey forProject:projectKey
            description:description object:object token:token
            requestId:requestId error:response];
    else
        [delegate editedMessage:messageKey forProject:projectKey
            description:description object:object token:token
            requestId:requestId response:response];

    [arguments removeObjectForKey:requestId];
}

- (void)handleAddMessageCommentResponse:(id)response
                              toRequest:(NSURLRequest *)request
                                 object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id messageKey = [args objectForKey:@"messageKey"];
    id projectKey = [args objectForKey:@"projectKey"];
    NSString * comment = [args objectForKey:@"comment"];
    id object = [args objectForKey:@"object"];
    object = [object isEqual:[NSNull null]] ? nil : object;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToAddComment:comment toMessage:messageKey
            forProject:projectKey object:object token:token requestId:requestId
            error:response];
    else
        [delegate addedComment:comment toMessage:messageKey
            forProject:projectKey object:object token:token requestId:requestId
            response:response];

    [arguments removeObjectForKey:requestId];
}

- (void)handleTicketSearchResultsForAllProjectsResponse:(id)response
                                              toRequest:(NSURLRequest *)request
                                                 object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    NSString * searchString = [args objectForKey:@"searchString"];
    NSUInteger page = [[args objectForKey:@"page"] integerValue];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToSearchTicketsForAllProjects:searchString
            page:page token:token requestId:requestId error:response];
    else
        [delegate searchResults:response
            fetchedForAllProjectsWithSearchString:searchString page:page
            token:token requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleTicketSearchResultsResponse:(id)response
                                toRequest:(NSURLRequest *)request
                                   object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    NSString * searchString = [args objectForKey:@"searchString"];
    id projectKey = [args objectForKey:@"projectKey"];
    NSUInteger page = [[args objectForKey:@"page"] integerValue];
    id obj = [args objectForKey:@"object"];
    obj = [obj isEqual:[NSNull null]] ? nil : obj;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToSearchTicketsForProject:projectKey
            searchString:searchString page:page object:obj token:token
            requestId:requestId error:response];
    else
        [delegate searchResults:response fetchedForProject:projectKey
            searchString:searchString page:page object:obj token:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleTicketCreationResponse:(id)response
                           toRequest:(NSURLRequest *)request
                              object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];
    NSString * description = [args objectForKey:@"description"];
    id object = [args objectForKey:@"object"];
    object = [object isEqual:[NSNull null]] ? nil : object;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToCreateTicketWithDescription:description
            forProject:projectKey object:object token:token
            requestId:requestId error:response];
    else
        [delegate ticketCreated:response description:description
            forProject:projectKey object:object token:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleEditTicketResponse:(id)response
                       toRequest:(NSURLRequest *)request
                          object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey  = [args objectForKey:@"projectKey"];
    id ticketKey = [args objectForKey:@"ticketKey"];
    NSString * description = [args objectForKey:@"description"];
    id object = [args objectForKey:@"object"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToEditTicket:ticketKey forProject:projectKey
            description:description object:object token:token
            requestId:requestId error:response];
    else
        [delegate editedTicket:ticketKey forProject:projectKey
            withDescription:description object:object response:response
            token:token requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleDeleteTicketResponse:(id)response
                         toRequest:(NSURLRequest *)request
                            object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey  = [args objectForKey:@"projectKey"];
    id ticketKey = [args objectForKey:@"ticketKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToDeleteTicket:ticketKey forProject:projectKey
            token:token requestId:requestId error:response];
    else
        [delegate deletedTicket:ticketKey forProject:projectKey
            response:response token:token requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleTicketBinResponse:(id)response
                      toRequest:(NSURLRequest *)request
                         object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchTicketBinsForProject:projectKey
                                              token:token
                                          requestId:requestId
                                              error:response];
    else
        [delegate ticketBins:response fetchedForProject:projectKey token:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleAllUsersForProjectResponse:(id)response
                               toRequest:(NSURLRequest *)request
                                  object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchAllUsersForProject:projectKey
                                            token:token
                                        requestId:requestId
                                            error:response];
    else
        [delegate allUsers:response fetchedForProject:projectKey token:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

- (void)handleAllProjectsResponse:(id)response
                        toRequest:(NSURLRequest *)request
                           object:(id)requestId
{
    NSDictionary * args = [arguments objectForKey:requestId];

    NSString * token = [args objectForKey:@"token"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchAllProjects:token requestId:requestId
            error:response];
    else
        [delegate projects:response fetchedForAllProjects:token
            requestId:requestId];

    [arguments removeObjectForKey:requestId];
}

#pragma mark WebSericeApiDelegate implementation

- (void)request:(NSURLRequest *)request
    didCompleteWithResponse:(NSData *)response
{
    [dispatcher dispatchResponse:response toRequest:request];
}

- (void)request:(NSURLRequest *)request
    didFailWithError:(NSError *)error
{
    [dispatcher dispatchResponse:error toRequest:request];
}

#pragma mark Request dispatching helpers

- (void)sendRequestToUrl:(NSString *)urlString callback:(SEL)sel
    object:(id)object
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    [dispatcher request:req isHandledBySelector:sel target:self object:object];

    [api sendRequest:req];
}

+ (id)uniqueRequestId
{
    return [RandomNumber randomNumber];
}

@end
