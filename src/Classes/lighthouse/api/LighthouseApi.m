//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApi.h"
#import "WebServiceApi.h"
#import "WebServiceResponseDispatcher.h"

@interface LighthouseApi ()

- (void)sendRequestToUrl:(NSString *)urlString
                callback:(SEL)sel
               arguments:(NSDictionary *)args;

@end

@implementation LighthouseApi

@synthesize delegate;

- (void)dealloc
{
    [baseUrlString release];

    [api release];
    [dispatcher release];

    [super dealloc];
}

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString
{
    if (self = [super init]) {
        baseUrlString = [aBaseUrlString copy];
        api = [[WebServiceApi alloc] initWithDelegate:self];
        dispatcher = [[WebServiceResponseDispatcher alloc] init];
    }

    return self;
}

#pragma mark Tickets

- (void)fetchTicketsForAllProjects:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@tickets.xml?_token=%@", baseUrlString,
        token];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    SEL sel = @selector(handleTicketsForAllProjectsResponse:toRequest:object:);

    [dispatcher request:req isHandledBySelector:sel target:self object:args];

    [api sendRequest:req];
}

- (void)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets/%@.xml?_token=%@",
        baseUrlString, projectKey, ticketKey, token];

    SEL sel = @selector(handleTicketDetailsResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token", projectKey, @"projectKey", ticketKey, @"ticketKey",
        nil];

    [self sendRequestToUrl:urlString callback:sel arguments:args];
}

- (void)searchTicketsForAllProjects:(NSString *)searchString
                              token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@tickets.xml?q=%@&_token=%@",
        baseUrlString,
        [searchString
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        token];
    NSURLRequest * req =
        [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token", searchString, @"searchString", nil];

    SEL sel =
        @selector(handleTicketSearchResultsForAllProjectsResponse:toRequest:\
            object:);

    [dispatcher request:req isHandledBySelector:sel target:self object:args];

    [api sendRequest:req];
}

- (void)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString object:(id)object
    token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets.xml?q=%@&_token=%@",
        baseUrlString,
        projectKey,
        [searchString
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        token];
    NSURLRequest * req =
        [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        searchString, @"searchString",
        projectKey, @"projectKey",
        object ? object : [NSNull null], @"object",
        nil];

    SEL sel = @selector(handleTicketSearchResultsResponse:toRequest:object:);
    [dispatcher request:req isHandledBySelector:sel target:self object:args];

    [api sendRequest:req];
}

- (void)beginTicketCreationForProject:(id)projectKey
                               object:(id)object
                                token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets/new.xml?_token=%@",
        baseUrlString, projectKey, token];
    SEL sel = @selector(handleBeginTicketCreationResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token",
        projectKey, @"projectKey",
        object ? object : [NSNull null], @"object",
        nil];

    [self sendRequestToUrl:urlString callback:sel arguments:args];
}

- (void)completeTicketCreationForProject:(id)projectKey
                             description:(NSString *)description
                                  object:(id)object
                                   token:(NSString *)token
{
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

    SEL sel =
        @selector(handleCompleteTicketCreationResponse:toRequest:args:);
    [dispatcher request:req isHandledBySelector:sel target:self object:args];

    [api sendRequest:req];
}

#pragma mark Ticket Bins

- (void)fetchTicketBinsForProject:(NSUInteger)projectId token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%u/bins.xml?_token=%@",
        baseUrlString, projectId, token];
    SEL sel = @selector(handleTicketBinResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token", [NSNumber numberWithInteger:projectId], @"projectId",
        nil];

    [self sendRequestToUrl:urlString callback:sel arguments:args];
}

#pragma mark Users

- (void)fetchAllUsersForProject:(id)projectKey token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/memberships.xml?_token=%@",
        baseUrlString, projectKey, token];

    SEL callback =
        @selector(handleAllUsersForProjectResponse:toRequest:object:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:
        token, @"token", projectKey, @"projectKey", nil];

    [self sendRequestToUrl:urlString callback:callback arguments:args];
}

#pragma mark Projects

- (void)fetchAllProjects:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects.xml?_token=%@",
        baseUrlString, token];

    SEL callback =
        @selector(handleAllProjectsResponse:toRequest:args:);
    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];

    [self sendRequestToUrl:urlString callback:callback arguments:args];
}

#pragma mark Milestones

- (void)fetchMilestonesForAllProjects:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@milestones.xml?_token=%@", baseUrlString,
        token];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    SEL sel =
        @selector(handleMilestonesForAllProjectsResponse:toRequest:object:);

    [dispatcher request:req isHandledBySelector:sel target:self object:args];

    [api sendRequest:req];
}

#pragma mark Handling responses

- (void)handleTicketsForAllProjectsResponse:(id)response
                                  toRequest:(NSURLRequest *)request
                                     object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchTicketsForAllProjects:token error:response];
    else
        [delegate tickets:response fetchedForAllProjectsWithToken:token];
}

- (void)handleTicketDetailsResponse:(id)response
                          toRequest:(NSURLRequest *)request
                             object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    id projectKey = [object objectForKey:@"projectKey"];
    id ticketKey = [object objectForKey:@"ticketKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchTicketDetailsForTicket:ticketKey
            inProject:projectKey token:token error:response];
    else
        [delegate details:response fetchedForTicket:ticketKey
            inProject:projectKey token:token];
}

- (void)handleMilestonesForAllProjectsResponse:(id)response
                                     toRequest:(NSURLRequest *)request
                                        object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchMilestonesForAllProjects:token error:response];
    else
        [delegate milestones:response fetchedForAllProjectsWithToken:token];
}

- (void)handleTicketSearchResultsForAllProjectsResponse:(id)response
                                              toRequest:(NSURLRequest *)request
                                                 object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    NSString * searchString = [object objectForKey:@"searchString"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToSearchTicketsForAllProjects:searchString
                                                token:token
                                                error:response];
    else
        [delegate searchResults:response
            fetchedForAllProjectsWithSearchString:searchString token:token];
}

- (void)handleTicketSearchResultsResponse:(id)response
                                toRequest:(NSURLRequest *)request
                                   object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    NSString * searchString = [object objectForKey:@"searchString"];
    id projectKey = [object objectForKey:@"projectKey"];
    id obj = [object objectForKey:@"object"];
    obj = [obj isEqual:[NSNull null]] ? nil : obj;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToSearchTicketsForProject:projectKey
            searchString:searchString object:obj token:token error:response];
    else
        [delegate searchResults:response fetchedForProject:projectKey
            searchString:searchString object:obj token:token];
}

- (void)handleBeginTicketCreationResponse:(id)response
                                toRequest:(NSURLRequest *)request
                                   object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    id projectKey = [object objectForKey:@"projectKey"];
    id userObject = [object objectForKey:@"object"];
    userObject = [userObject isEqual:[NSNull null]] ? nil : userObject;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToBeginTicketCreationForProject:projectKey
                                                 object:userObject
                                                  token:token
                                                  error:response];
    else
        [delegate ticketCreationDidBegin:response
                              forProject:projectKey
                                  object:userObject
                                   token:token];
}

- (void)handleCompleteTicketCreationResponse:(id)response
                                   toRequest:(NSURLRequest *)request
                                        args:(NSDictionary *)args
{
    NSString * token = [args objectForKey:@"token"];
    id projectKey = [args objectForKey:@"projectKey"];
    NSString * description = [args objectForKey:@"description"];
    id object = [args objectForKey:@"object"];
    object = [object isEqual:[NSNull null]] ? nil : object;

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToCompleteTicketCreation:description
                                      forProject:projectKey
                                          object:object
                                           token:token
                                           error:response];
    else
        [delegate ticketCreated:response
                    description:description
                     forProject:projectKey
                         object:object
                          token:token];
}

- (void)handleTicketBinResponse:(id)response
                      toRequest:(NSURLRequest *)request
                         object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    NSUInteger projectId = [[object objectForKey:@"projectId"] integerValue];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchTicketBinsForProject:projectId
                                              token:token
                                              error:response];
    else
        [delegate ticketBins:response fetchedForProject:projectId token:token];
}

- (void)handleAllUsersForProjectResponse:(id)response
                               toRequest:(NSURLRequest *)request
                                  object:(id)object
{
    NSString * token = [object objectForKey:@"token"];
    id projectKey = [object objectForKey:@"projectKey"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchAllUsersForProject:projectKey
                                            token:token
                                            error:response];
    else
        [delegate allUsers:response fetchedForProject:projectKey token:token];
}

- (void)handleAllProjectsResponse:(id)response
                        toRequest:(NSURLRequest *)request
                             args:(NSDictionary *)args
{
    NSString * token = [args objectForKey:@"token"];

    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchAllProjects:token error:response];
    else
        [delegate projects:response fetchedForAllProjects:token];
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

- (void)sendRequestToUrl:(NSString *)urlString
                callback:(SEL)sel
               arguments:(NSDictionary *)args
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    [dispatcher request:req isHandledBySelector:sel target:self object:args];

    [api sendRequest:req];
}

@end
