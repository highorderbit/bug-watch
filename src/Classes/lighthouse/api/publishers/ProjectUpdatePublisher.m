//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "ProjectUpdatePublisher.h"
#import "LighthouseApiService.h"

@implementation ProjectUpdatePublisher

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

    NSArray * projects = [info objectForKey:@"projects"];
    NSArray * projectKeys = [info objectForKey:@"projectKeys"];

    NSArray * args = [NSArray arrayWithObjects:projects, projectKeys, nil];

    [self notifyListener:args];
}

- (NSString *)notificationName
{
    return [LighthouseApiService allProjectsReceivedNotificationName];
}

@end
