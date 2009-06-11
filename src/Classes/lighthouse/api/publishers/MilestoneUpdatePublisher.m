//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneUpdatePublisher.h"
#import "LighthouseApiService.h"

@implementation MilestoneUpdatePublisher

+ (id)publisherWithListener:(id)listener action:(SEL)action;
{
    id obj = [[[self class] alloc] initWithListener:listener action:action];
    return [obj autorelease];
}

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithListener:(id)listener action:(SEL)action;
{
    return (self = [super initWithListener:listener action:action]);
}

#pragma mark Receiving notifications

- (void)notificationReceived:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;

    NSArray * milestones = [info objectForKey:@"milestones"];
    NSArray * milestoneKeys = [info objectForKey:@"milestoneKeys"];
    NSArray * projectKeys = [info objectForKey:@"projectKeys"];

    NSArray * args =
        [NSArray arrayWithObjects:milestones, milestoneKeys, projectKeys, nil];

    [self notifyListener:args];
}

- (NSString *)notificationName
{
    return
        [LighthouseApiService milestonesReceivedForAllProjectsNotificationName];
}

@end
