//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseAccountAuthenticator.h"
#import "LighthouseApi.h"
#import "LighthouseCredentials.h"
#import "LighthouseUrlBuilder.h"
#import "ResponseProcessors.h"
#import "BugWatchObjectBuilder.h"
#import "LogInResponseProcessor.h"

@interface LighthouseAccountAuthenticator ()

@property (nonatomic, copy) NSString * lighthouseDomain;
@property (nonatomic, copy) NSString * lighthouseScheme;

- (ResponseProcessor *)processorForRequest:(id)requestId;
- (void)requestCompleted:(id)requestId;
- (void)safelyCleanDictionary:(NSMutableDictionary *)dict
                    ofRequest:(id)requestId;

@end

@implementation LighthouseAccountAuthenticator

@synthesize delegate, lighthouseDomain, lighthouseScheme;

- (void)dealloc
{
    self.delegate = nil;

    self.lighthouseDomain = nil;
    self.lighthouseScheme = nil;

    [apis release];
    [processors release];

    [builder release];

    [super dealloc];
}

- (id)initWithLighthouseDomain:(NSString *)domain
                        scheme:(NSString *)scheme
{
    if (self = [super init]) {
        self.lighthouseDomain = domain;
        self.lighthouseScheme = scheme;

        apis = [[NSMutableDictionary alloc] init];
        processors = [[NSMutableDictionary alloc] init];

        // should the builder be supplied as an initializer argument?
        LighthouseApiParser * parser = [LighthouseApiParser parser];
        builder = [[BugWatchObjectBuilder alloc] initWithParser:parser];
    }

    return self;
}

- (void)authenticateCredentials:(LighthouseCredentials *)credentials
{
    LighthouseUrlBuilder * urlBuilder =
        [LighthouseUrlBuilder builderWithLighthouseDomain:lighthouseDomain
                                                   scheme:lighthouseScheme];

    LighthouseApi * api =
        [[LighthouseApi alloc] initWithUrlBuilder:urlBuilder
                                      credentials:credentials];
    api.delegate = self;

    ResponseProcessor * processor =
        [LogInResponseProcessor processorWithCredentials:credentials
                                                delegate:delegate];

    // call a method with a small payload
    id requestId = [api fetchAllProjects];

    [apis setObject:api forKey:requestId];
    [processors setObject:processor forKey:requestId];

    [api release];
}

#pragma mark LighthouseApiDelegate implementation

- (void)request:(id)requestId succeededWithResponse:(NSData *)response
{
    [[self processorForRequest:requestId] process:response];
    [self requestCompleted:requestId];
}

- (void)request:(id)requestId failedWithError:(NSError *)error
{
    [[self processorForRequest:requestId] processError:error];
    [self requestCompleted:requestId];
}

- (ResponseProcessor *)processorForRequest:(id)requestId
{
    ResponseProcessor * processor = [processors objectForKey:requestId];
    NSAssert1(processor, @"Failed to find response processor for request ID: "
        "'%@'.", requestId);

    return processor;
}

- (void)requestCompleted:(id)requestId
{
    [self safelyCleanDictionary:apis ofRequest:requestId];
    [self safelyCleanDictionary:processors ofRequest:requestId];
}

- (void)safelyCleanDictionary:(NSMutableDictionary *)dict
                    ofRequest:(id)requestId
{
    id obj = [dict objectForKey:requestId];
    [[obj retain] autorelease];
    [dict removeObjectForKey:requestId];
}

@end
