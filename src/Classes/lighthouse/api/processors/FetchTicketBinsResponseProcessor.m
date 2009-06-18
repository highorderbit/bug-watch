//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchTicketBinsResponseProcessor.h"

@interface FetchTicketBinsResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSArray * ticketBins;

@end

@implementation FetchTicketBinsResponseProcessor

@synthesize projectKey, delegate;
@synthesize ticketBins;

+ (id)processorWithProjectKey:(id)aProjectKey
                     delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithProjectKey:aProjectKey
                                             delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.projectKey = nil;
    self.delegate = nil;

    self.ticketBins = nil;

    [super dealloc];
}

- (id)initWithProjectKey:(id)aProjectKey
                delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponseAsynchronously:(NSData *)xml
{
    self.ticketBins = [self.objectBuilder parseTicketBins:xml];
}

- (void)asynchronousProcessorFinished
{
    SEL sel = @selector(fetchedTicketBins:forProject:);
    [self invokeSelector:sel withTarget:delegate args:ticketBins, projectKey,
        nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchTicketBinsForProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:projectKey, errors, nil];
}

@end
