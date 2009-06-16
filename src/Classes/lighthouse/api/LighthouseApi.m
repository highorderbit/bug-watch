//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApi.h"
#import "WebServiceApi.h"
#import "WebServiceResponseDispatcher.h"
#import "LighthouseUrlBuilder.h"
#import "NSString+UrlEncodingAdditions.h"

@interface LighthouseApi ()

- (id)sendRequestToPath:(NSString *)path;
- (id)sendRequestToPath:(NSString *)path args:(id)firstArg, ...
    NS_REQUIRES_NIL_TERMINATION;

- (id)sendRequestToUrlString:(NSString *)urlString;
- (id)sendRequestToUrl:(NSURL *)url;
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
    [urlBuilder release];
    [credentials release];

    [api release];
    [dispatcher release];

    [super dealloc];
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

- (id)fetchTicketsForAllProjects
{
    return [self sendRequestToPath:@"tickets.xml"];
}

- (id)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
{
    return [self sendRequestToPath:
        [NSString stringWithFormat:@"projects/%@/tickets/%@.xml",
            projectKey, ticketKey]];
}

- (id)searchTicketsForAllProjects:(NSString *)searchString
                             page:(NSUInteger)aPage
{
    NSNumber * page = [NSNumber numberWithInteger:aPage];

    if (searchString.length == 0)
        return [self sendRequestToPath:@"tickets.xml" args:@"page", page, nil];
    else {
        NSString * encodedSearchString = [searchString urlEncodedString];
        return [self sendRequestToPath:@"tickets.xml"
                                  args:@"q", encodedSearchString,
                                       @"page", page, nil];
    }
}

- (id)searchTicketsForProject:(id)projectKey
             withSearchString:(NSString *)searchString
                         page:(NSUInteger)aPage
{
    NSNumber * page = [NSNumber numberWithInteger:aPage];
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/tickets.xml", projectKey];

    if (searchString.length == 0)
        return [self sendRequestToPath:path args:@"page", page, nil];
    else {
        NSString * encodedSearchString = [searchString urlEncodedString];
        return [self sendRequestToPath:path args:@"q", encodedSearchString,
           @"page", page, nil];
    }
}

- (id)createTicketForProject:(id)projectKey description:(NSString *)description
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/tickets.xml", projectKey];
    NSURL * url = [urlBuilder urlForPath:path];
    url = [credentials authenticateUrl:url];
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];

    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    return [self sendRequest:req];
}

#pragma mark Tickets -- editing

- (id)editTicket:(id)ticketKey
      forProject:(id)projectKey
     description:(NSString *)description
{
    NSAssert(ticketKey, @"Ticket key cannot be nil.");
    NSAssert(projectKey, @"Project key cannot be nil.");
    NSAssert(description, @"Description cannot be nil.");

    NSString * path =
        [NSString stringWithFormat:@"projects/%@/tickets/%@.xml",
        projectKey, ticketKey];
    NSURL * url = [urlBuilder urlForPath:path];
    url = [credentials authenticateUrl:url];
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];

    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    [req setHTTPMethod:@"PUT"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    return [self sendRequest:req];
}

#pragma mark Tickets -- deleting

- (id)deleteTicket:(id)ticketKey forProject:(id)projectKey
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/tickets/%@.xml", projectKey,
        ticketKey];
    NSURL * url = [urlBuilder urlForPath:path];
    url = [credentials authenticateUrl:url];

    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"DELETE"];

    return [self sendRequest:req];
}

#pragma mark Ticket Bins

- (id)fetchTicketBinsForProject:(id)projectKey
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/bins.xml", projectKey];
    return [self sendRequestToPath:path];
}

#pragma mark Users

- (id)fetchAllUsersForProject:(id)projectKey
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/memberships.xml",
        projectKey];

    return [self sendRequestToPath:path];
}

#pragma mark Projects

- (id)fetchAllProjects
{
    return [self sendRequestToPath:@"projects.xml"];
}

#pragma mark Milestones

- (id)fetchMilestonesForAllProjects
{
    return [self sendRequestToPath:@"milestones.xml"];
}

#pragma mark Messages

- (id)fetchMessagesForProject:(id)projectKey
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/messages.xml", projectKey];
    return [self sendRequestToPath:path];
}

- (id)fetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/messages/%@.xml", projectKey,
        messageKey];

    return [self sendRequestToPath:path];
}

#pragma mark Messages -- creating

- (id)createMessageForProject:(id)projectKey
                  description:(NSString *)description
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/messages.xml", projectKey];
    NSURL * url = [urlBuilder urlForPath:path];
    url = [credentials authenticateUrl:url];
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];

    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    return [self sendRequest:req];
}

#pragma mark Messages -- editing

- (id)editMessage:(id)messageKey
       forProject:(id)projectKey
      description:(NSString *)description
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/messages/%@.xml", projectKey,
        messageKey];
    NSURL * url = [urlBuilder urlForPath:path];
    url = [credentials authenticateUrl:url];
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];

    NSData * encodedDescription =
        [description dataUsingEncoding:NSUTF8StringEncoding];

    [req setHTTPMethod:@"PUT"];
    [req setHTTPBody:encodedDescription];
    [req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];

    return [self sendRequest:req];
}

#pragma mark Messages -- adding comments

- (id)addComment:(NSString *)comment
       toMessage:(id)messageKey
      forProject:(id)projectKey
{
    NSString * path =
        [NSString stringWithFormat:@"projects/%@/messages/%@/comments.xml",
        projectKey, messageKey];
    NSURL * url = [urlBuilder urlForPath:path];
    url = [credentials authenticateUrl:url];
    NSMutableURLRequest * req = [NSMutableURLRequest requestWithURL:url];

    NSData * encodedDescription =
        [comment dataUsingEncoding:NSUTF8StringEncoding];

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

- (id)sendRequestToPath:(NSString *)path
{
    return [self sendRequestToPath:path args:nil];
}

- (id)sendRequestToPath:(NSString *)path args:(id)firstArg, ...
{
    NSMutableArray * args = [NSMutableArray array];

    va_list list;
    va_start(list, firstArg);

    for (id arg = firstArg; arg != nil; arg = va_arg(list, id))
        [args addObject:arg];

    va_end(list);

    NSURL * url = [urlBuilder urlForPath:path allArgs:args];
    url = [credentials authenticateUrl:url];

    return [self sendRequestToUrl:url];
}

- (id)sendRequestToUrl:(NSURL *)url
{
    return [self sendRequest:[NSURLRequest requestWithURL:url]];
}

- (id)sendRequestToUrlString:(NSString *)urlString
{
    return [self sendRequestToUrl:[NSURL URLWithString:urlString]];
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
