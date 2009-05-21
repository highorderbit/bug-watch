//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UserUpdatePublisher.h"
#import "LighthouseApiService.h"

@interface UserUpdatePublisher ()

- (void)subscribeForNotifications;
- (void)unsubscribeForNotifications;

@end

@implementation UserUpdatePublisher

+ (id)publisherWithListener:(id)listener action:(SEL)action
{
    id obj = [[[self class] alloc] initWithListener:listener action:action];
    return [obj autorelease];
}

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

#pragma mark Receiving notifications

- (void)notificationRecived:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;

    NSDictionary * users = [info objectForKey:@"users"];
    id projectKey = [info objectForKey:@"projectKey"];

    [invocation setArgument:&users atIndex:2];
    [invocation setArgument:&projectKey atIndex:3];
    [invocation invoke];
}

#pragma mark Subscribing for notifications

- (void)subscribeForNotifications
{
    NSString * notificationName =
        [LighthouseApiService usersRecevedForProjectNotificationName];
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self
           selector:@selector(notificationRecived:)
               name:notificationName
             object:nil];
}

- (void)unsubscribeForNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
