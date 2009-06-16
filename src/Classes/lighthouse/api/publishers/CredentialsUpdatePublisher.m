//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CredentialsUpdatePublisher.h"
#import "LighthouseAccountAuthenticator.h"

@implementation CredentialsUpdatePublisher

+ (id)publisherWithListener:(id)listener action:(SEL)action
{
    id obj = [[[self class] alloc] initWithListener:listener action:action];
    return [obj autorelease];
}

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithListener:(id)listener action:(SEL)action
{
    return (self = [super initWithListener:listener action:action]);
}

#pragma mark Receiving notifications

- (void)notificationReceived:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;

    id credentials = [info objectForKey:@"credentials"];
    NSArray * args = [NSArray arrayWithObject:credentials];

    [self notifyListener:args];
}

#pragma mark Subscribing for notifications

- (NSString *)notificationName
{
    return [LighthouseAccountAuthenticator credentialsChangedNotificationName];
}

@end
