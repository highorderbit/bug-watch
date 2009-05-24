//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AbstractUpdatePublisher.h"

@interface AbstractUpdatePublisher ()

- (NSString *)notificationName;  // to be provided by subclasses
- (void)subscribeForNotifications;
- (void)unsubscribeForNotifications;

@end

@implementation AbstractUpdatePublisher

- (void)dealloc
{
    [self unsubscribeForNotifications];
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

        [self subscribeForNotifications];
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

- (NSString *)notificationName
{
    NSAssert(NO, @"Subclasses must implement notificationName.");
    return nil;
}

- (void)subscribeForNotifications
{
    // provided by subclasses
    NSString * notificationName = [self notificationName];
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self
           selector:@selector(notificationReceived:)
               name:notificationName
             object:nil];
}

- (void)unsubscribeForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
