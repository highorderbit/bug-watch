//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CredentialsUpdatePublisher.h"
#import "LogInDisplayMgr.h"

@interface CredentialsUpdatePublisher ()

@property (nonatomic, assign) id listener;
@property (nonatomic, assign) SEL action;

@end

@implementation CredentialsUpdatePublisher

@synthesize listener, action;

+ (id)publisherWithListener:(id)aListener action:(SEL)anAction
{
    id obj = [[[self class] alloc] initWithListener:aListener action:anAction];
    return [obj autorelease];
}

- (void)dealloc
{
    self.listener = nil;
    self.action = nil;
    [super dealloc];
}

- (id)initWithListener:(id)aListener action:(SEL)anAction
{
    if (self = [super initWithListener:aListener action:anAction]) {
        self.listener = aListener;
        self.action = anAction;
    }

    return self;
}

#pragma mark Receiving notifications

- (void)notificationReceived:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;

    id credentials = [info objectForKey:@"credentials"];
    [self.listener performSelector:self.action withObject:credentials];
}

#pragma mark Subscribing for notifications

- (NSString *)notificationName
{
    return [LogInDisplayMgr credentialsChangedNotificationName];
}

@end
