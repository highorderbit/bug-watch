//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApi.h"
#import "WebServiceApi.h"
#import "WebServiceResponseDispatcher.h"
#import "LighthouseUrlBuilder.h"

@interface LighthouseApi ()

- (id)sendRequestToUrl:(NSString *)urlString;
- (id)sendRequest:(NSURLRequest *)request;

@end

@implementation LighthouseApi

@synthesize delegate, credentials;

+ (id)apiWithUrlBuilder:(LighthouseUrlBuilder *)aUrlBuilder
            credentials:(LighthouseCredentials *)someCredentials
{
    id obj = [[[self class] alloc] initWithUrlBuilder:aUrlBuilder
                                          credentials:someCredentials];
    return [obj autorelease];
}

- (void)dealloc
{
    [baseUrlString release];
    [urlBuilder release];
    [credentials release];

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

- (id)initWithUrlBuilder:(LighthouseUrlBuilder *)aUrlBuilder
             credentials:(LighthouseCredentials *)someCredentials
{
    if (self = [super init]) {
        urlBuilder = [aUrlBuilder copy];
        self.credentials = someCredentials;

        api = [[WebServiceApi alloc] initWithDelegate:self];
        dispatcher = [[WebServiceResponseDispatcher alloc] init];
    }

    return self;
}

#pragma mark Tickets

- (id)fetchTicketsForAllProjects:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@tickets.xml?_token=%@", baseUrlString,
        token];

    return [self sendRequestToUrl:urlString];
}

- (id)fetchTicketsForAllProjects
{
    NSURL * url = [urlBuilder urlForPath:@"tickets.xml"];
    url = [credentials authenticateUrl:url];

    return [self sendRequest:[NSURLRequest requestWithURL:url]];
}

- (id)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets/%@.xml?_token=%@",
        baseUrlString, projectKey, ticketKey, token];

    return [self sendRequestToUrl:urlString];
}

- (id)searchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@tickets.xml?q=%@&page=%u&_token=%@",
        baseUrlString,
        [searchString
            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
        page,
        token];

    return [self sendRequestToUrl:urlString];
}

- (id)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token
{
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

    return [self sendRequestToUrl:urlString];
}

- (id)createTicketForProject:(id)projectKey description:(NSString *)description
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

    return [self sendRequest:req];
}

#pragma mark Tickets -- editing

- (id)editTicket:(id)ticketKey forProject:(id)projectKey
    description:(NSString *)description token:(NSString *)token
{
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

    return [self sendRequest:req];
}

#pragma mark Tickets -- deleting

- (id)deleteTicket:(id)ticketKey forProject:(id)projectKey
    token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/tickets/%@.xml?_token=%@",
        baseUrlString, projectKey, ticketKey, token];

    NSMutableURLRequest * req =
        [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [req setHTTPMethod:@"DELETE"];

    return [self sendRequest:req];
}

#pragma mark Ticket Bins

- (id)fetchTicketBinsForProject:(id)projectKey token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/bins.xml?_token=%@",
        baseUrlString, projectKey, token];

    return [self sendRequestToUrl:urlString];
}

#pragma mark Users

- (id)fetchAllUsersForProject:(id)projectKey token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/memberships.xml?_token=%@",
        baseUrlString, projectKey, token];

    return [self sendRequestToUrl:urlString];
}

#pragma mark Projects

- (id)fetchAllProjects:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects.xml?_token=%@",
        baseUrlString, token];

    return [self sendRequestToUrl:urlString];
}

#pragma mark Milestones

- (id)fetchMilestonesForAllProjects:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@milestones.xml?_token=%@", baseUrlString,
        token];

    return [self sendRequestToUrl:urlString];
}

#pragma mark Messages

- (id)fetchMessagesForProject:(id)projectKey token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/messages.xml?_token=%@",
        baseUrlString, projectKey, token];

    return [self sendRequestToUrl:urlString];
}

- (id)fetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    token:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@projects/%@/messages/%@.xml?_token=%@",
        baseUrlString, projectKey, messageKey, token];

    return [self sendRequestToUrl:urlString];
}

#pragma mark Messages -- creating

- (id)createMessageForProject:(id)projectKey
    description:(NSString *)description token:(NSString *)token
{
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

    return [self sendRequest:req];
}

#pragma mark Messages -- editing

- (id)editMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description token:(NSString *)token
{
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

    return [self sendRequest:req];
}

#pragma mark Messages -- adding comments

- (id)addComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey token:(NSString *)token
{
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

    return [self sendRequest:req];
}

#pragma mark Handling responses

- (void)handleGeneralResponse:(id)response
                    toRequest:(NSURLRequest *)request
                    requestId:(id)requestId
{
    if ([response isKindOfClass:[NSError class]])
        [delegate request:requestId failedWithError:response];
    else
        [delegate request:requestId succeededWithResponse:response];
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

- (id)sendRequestToUrl:(NSString *)urlString
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    return [self sendRequest:req];
}

- (id)sendRequest:(NSURLRequest *)request
{
    SEL sel = @selector(handleGeneralResponse:toRequest:requestId:);

    // FIXME: Is it okay to cast an id to an int? How big is an id?
    id requestId = [NSNumber numberWithInteger:(NSInteger) request];

    [dispatcher
        request:request isHandledBySelector:sel target:self object:requestId];

    [api sendRequest:request];

    return requestId;
}

@end
