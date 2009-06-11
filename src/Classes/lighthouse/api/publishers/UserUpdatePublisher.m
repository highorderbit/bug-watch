//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UserUpdatePublisher.h"
#import "LighthouseApiService.h"

@implementation UserUpdatePublisher

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

    NSDictionary * users = [info objectForKey:@"users"];
    id projectKey = [info objectForKey:@"projectKey"];

    NSArray * args = [NSArray arrayWithObjects:users, projectKey, nil];

    [self notifyListener:args];
}

#pragma mark Subscribing for notifications

- (NSString *)notificationName
{
    return [LighthouseApiService usersRecevedForProjectNotificationName];
}

@end
