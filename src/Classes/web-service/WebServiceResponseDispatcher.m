//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "WebServiceResponseDispatcher.h"
#import "NSDictionary+NonRetainedKeyAdditions.h"

@implementation WebServiceResponseDispatcher

- (void)dealloc
{
    [invocations release];

    [super dealloc];
}

- (id)init
{
    if (self = [super init])
        invocations = [[NSMutableDictionary alloc] init];

    return self;
}

- (void)request:(NSURLRequest *)request isHandledBySelector:(SEL)selector
     target:(id)target object:(id<NSObject>)object
{
    NSMethodSignature * sig = [target methodSignatureForSelector:selector];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:target];
    [inv setSelector:selector];
    if (object)
        [inv setArgument:&object atIndex:4];
    [inv retainArguments];

    [invocations setObject:inv forNonRetainedKey:request];
}

- (void)dispatchResponse:(id)response toRequest:(NSURLRequest *)request
{
    NSInvocation * invocation = [invocations objectForNonRetainedKey:request];
    [invocation setArgument:&response atIndex:2];
    [invocation setArgument:&request atIndex:3];

    [invocation invoke];

    [invocations removeObjectForNonRetainedKey:request];
}

@end
