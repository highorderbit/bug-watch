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
