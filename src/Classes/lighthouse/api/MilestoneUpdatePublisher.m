//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneUpdatePublisher.h"
#import "LighthouseApiService.h"

@interface MilestoneUpdatePublisher ()

- (void)subscribeForNotifications;
- (void)unsubscribeForNotifications;

@end

@implementation MilestoneUpdatePublisher

+ (id)publisherWithListener:(id)listener action:(SEL)action;
{
    id obj = [[[self class] alloc] initWithListener:listener action:action];
    return [obj autorelease];
}

- (void)dealloc
{
    [self unsubscribeForNotifications];

    [super dealloc];
}

- (id)initWithListener:(id)listener action:(SEL)action;
{
    if (self = [super initWithListener:listener action:action])
        [self subscribeForNotifications];

    return self;
}

#pragma mark Receiving notifications

- (void)notificationRecived:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;

    NSArray * milestones = [info objectForKey:@"milestones"];
    NSArray * milestoneKeys = [info objectForKey:@"milestoneKeys"];
    NSArray * projectKeys = [info objectForKey:@"projectKeys"];

    NSArray * args =
        [NSArray arrayWithObjects:milestones, milestoneKeys, projectKeys, nil];

    [self notifyListener:args];
}

#pragma mark Helper methods

- (void)subscribeForNotifications
{
        NSString * notificationName =
            [LighthouseApiService
            milestonesReceivedForAllProjectsNotificationName];
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
