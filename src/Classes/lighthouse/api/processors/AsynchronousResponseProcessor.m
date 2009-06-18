//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AsynchronousResponseProcessor.h"
#import "AsynchronousInvocation.h"

@interface AsynchronousResponseProcessor ()

@property (nonatomic, retain) AsynchronousInvocation * asynchronousInvocation;

- (void)asynchronousProcessorFinished;  // to be implemented by subclasses

@end

@implementation AsynchronousResponseProcessor

@synthesize asynchronousInvocation;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder];
    return [obj autorelease];
}

- (void)dealloc
{
    self.asynchronousInvocation = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
{
    return (self = [super initWithBuilder:aBuilder]);
}

- (void)processResponse:(NSData *)xml
{
    SEL sel = @selector(processResponseAsynchronously:);
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    NSInvocation * invocation =
        [NSInvocation invocationWithMethodSignature:sig];

    [invocation setTarget:self];
    [invocation setSelector:sel];
    [invocation setArgument:&xml atIndex:2];
    [invocation retainArguments];

    self.asynchronousInvocation = [AsynchronousInvocation invocation];

    SEL returnSelector = @selector(asynchronousProcessorFinished:);
    [self.asynchronousInvocation
        executeInvocationAsynchronously:invocation
                   returnValueRecipient:self
                               selector:returnSelector];
}

- (void)asynchronousProcessorFinished:(NSInvocation *)invocation
{
    [self asynchronousProcessorFinished];
}

- (void)asynchronousProcessorFinished
{
    NSAssert(NO, @"This function must be implemented by subclasses.");
}

@end
