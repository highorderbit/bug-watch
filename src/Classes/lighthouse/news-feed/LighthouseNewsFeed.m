//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseNewsFeed.h"
#import "WebServiceApi.h"
#import "WebServiceResponseDispatcher.h"

@implementation LighthouseNewsFeed

@synthesize delegate, credentials;

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

- (void)fetchNewsFeed
{
    NSURL * url = [urlBuilder urlForPath:@"events.atom"];
    url = [credentials authenticateUrl:url];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];

    SEL sel = @selector(handleNewsFeedResponse:toRequest:object:);
    [dispatcher request:req isHandledBySelector:sel target:self object:nil];

    [api sendRequest:req];
}

#pragma mark Handling news feed responses

- (void)handleNewsFeedResponse:(id)response
                     toRequest:(NSURLRequest *)request
                        object:(id)object
{
    if ([response isKindOfClass:[NSError class]])
        [delegate failedToFetchNewsFeed:response];
    else
        [delegate fetchedNewsFeed:response];
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
