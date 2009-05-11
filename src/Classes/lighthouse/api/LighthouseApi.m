//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApi.h"
#import "WebServiceApi.h"
#import "WebServiceResponseDispatcher.h"

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

#pragma mark Fetching tickets

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

@end
