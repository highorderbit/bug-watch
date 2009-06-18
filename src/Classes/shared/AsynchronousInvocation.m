//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AsynchronousInvocation.h"

@implementation AsynchronousInvocation

+ (id)invocation
{
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc
{
    [invocation release];
    [returnValueRecipient release];
    [returnValueThread release];
    [invocationThread release];
    [autoReleasePool release];
    [super dealloc];
}

- (id)init
{
    return (self = [super init]);
}

- (void)executeInvocationAsynchronously:(NSInvocation *)anInvocation
                   returnValueRecipient:(id)recipient
                               selector:(SEL)selector
{
    invocation = [anInvocation retain];
    returnValueRecipient = [recipient retain];
    returnValueSelector = selector;
    returnValueThread = [[NSThread currentThread] retain];

    invocationThread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(threadStart:)
                                                 object:nil];

    [invocationThread start];
}

- (void)threadStart:(id)object
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    [invocation invoke];

    [returnValueRecipient performSelector:returnValueSelector
                                 onThread:returnValueThread
                               withObject:invocation
                            waitUntilDone:NO];

    [pool release];
}

@end
