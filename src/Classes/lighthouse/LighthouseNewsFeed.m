//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseNewsFeed.h"
#import "WebServiceApi.h"
#import "WebServiceResponseDispatcher.h"

@implementation LighthouseNewsFeed

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

- (void)fetchNewsFeed:(NSString *)token
{
    NSString * urlString =
        [NSString stringWithFormat:@"%@?_token=%@", baseUrlString, token];
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    NSDictionary * args =
        [NSDictionary dictionaryWithObjectsAndKeys:token, @"token", nil];
    SEL sel = @selector(handleNewsFeedResponse:toRequest:object:);

    [dispatcher request:req isHandledBySelector:sel target:self object:args];

    [api sendRequest:req];
}

#pragma mark Handling news feed responses

- (void)handleNewsFeedResponse:(id)response toRequest:(NSURLRequest *)request
    object:(id)object
{
    NSLog(@"Have response: '%@' to request: '%@' args: '%@'.", response,
        request, object);

    NSString * token = [object objectForKey:@"token"];
    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchNewsFeedForToken:token error:response];
    else
        [delegate newsFeed:response fetchedForToken:token];
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
