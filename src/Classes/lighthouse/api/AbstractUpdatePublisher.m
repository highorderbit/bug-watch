//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AbstractUpdatePublisher.h"

@implementation AbstractUpdatePublisher

- (void)dealloc
{
    [invocation release];
    [super dealloc];
}

- (id)initWithListener:(id)listener action:(SEL)action
{
    if (self = [super init]) {
        NSMethodSignature * sig = [listener methodSignatureForSelector:action];
        invocation = [[NSInvocation invocationWithMethodSignature:sig] retain];
        [invocation setTarget:listener];
        [invocation setSelector:action];
    }

    return self;
}

#pragma mark Notifying the listener

- (void)notifyListener:(NSArray *)args
{
    for (NSInteger i = 0, count = args.count; i < count; ++i) {
        id object = [args objectAtIndex:i];
        [invocation setArgument:&object atIndex:i + 2];
    }

    [invocation invoke];
}

@end
