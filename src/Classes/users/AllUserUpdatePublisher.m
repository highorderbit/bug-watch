//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "AllUserUpdatePublisher.h"
#import "UserSetAggregator.h"
#import "User.h"

@implementation AllUserUpdatePublisher

+ (id)publisherWithListener:(id)listener action:(SEL)action
{
    id obj = [[[self class] alloc] initWithListener:listener action:action];

    return [obj autorelease];
}

#pragma mark Receiving notifications

- (void)notificationReceived:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;
    NSArray * users = [info objectForKey:@"users"];
    NSArray * userKeys = [info objectForKey:@"userKeys"];

    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < [users count]; i++) {
        User * user = [users objectAtIndex:i];
        id key = [userKeys objectAtIndex:i];
        [userDict setObject:user forKey:key];
    }

    NSLog(@"Publishing users: %@", userDict);
    NSArray * args = [NSArray arrayWithObjects:userDict, nil];
    [self notifyListener:args];
}

#pragma mark Subscribing for notifications

- (NSString *)notificationName
{
    return [UserSetAggregator allUsersReceivedNotificationName];
}

@end
