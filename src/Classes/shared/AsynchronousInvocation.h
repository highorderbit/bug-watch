//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsynchronousInvocation : NSObject
{
    NSInvocation * invocation;

    id returnValueRecipient;
    SEL returnValueSelector;
    NSThread * returnValueThread;

    NSThread * invocationThread;
    NSAutoreleasePool * autoReleasePool;
}

+ (id)invocation;

- (id)init;

- (void)executeInvocationAsynchronously:(NSInvocation *)anInvocation
                   returnValueRecipient:(id)recipient
                               selector:(SEL)selector;

@end
