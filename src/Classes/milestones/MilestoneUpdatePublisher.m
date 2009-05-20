//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneUpdatePublisher.h"
#import "LighthouseApiService.h"

@interface MilestoneUpdatePublisher ()

+ (NSString *)keyForTarget:(id)target
          notificationName:(NSString *)notificationName;

@end

@implementation MilestoneUpdatePublisher

+ (id)publisher
{
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [listeners release];

    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        NSString * notificationName =
            [LighthouseApiService
            milestonesReceivedForAllProjectsNotificationName];
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(notificationRecived:)
                   name:notificationName
                 object:nil];

        listeners = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)subscribeForMilestoneUpdatesForAllProjects:(id)target
                                            action:(SEL)action
{
    NSString * notificationName =
        [LighthouseApiService milestonesReceivedForAllProjectsNotificationName];
    NSString * key = [[self class] keyForTarget:target
                               notificationName:notificationName];

    NSMethodSignature * sig = [target methodSignatureForSelector:action];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:target];
    [inv setSelector:action];

    [listeners setObject:inv forKey:key];
}

- (void)unsubscribeForMilestoneUpdatesForAllProjets:(id)target
{
    NSString * notificationName =
        [LighthouseApiService milestonesReceivedForAllProjectsNotificationName];
    NSString * key = [[self class] keyForTarget:target
                               notificationName:notificationName];

    NSInvocation * inv = [listeners objectForKey:key];
    [[inv retain] autorelease];

    [listeners removeObjectForKey:key];
}

#pragma mark Receiving notifications

- (void)notificationRecived:(NSNotification *)notification
{
    NSDictionary * info = notification.userInfo;

    NSArray * milestones = [info objectForKey:@"milestones"];
    NSArray * milestoneKeys = [info objectForKey:@"milestoneKeys"];
    NSArray * projectKeys = [info objectForKey:@"projectKeys"];

    for (NSString * key in listeners) {
        NSInvocation * inv = [listeners objectForKey:key];
        [inv setArgument:&milestones atIndex:2];
        [inv setArgument:&milestoneKeys atIndex:3];
        [inv setArgument:&projectKeys atIndex:4];

        [inv invoke];
    }
}

#pragma mark Helper methods

+ (NSString *)keyForTarget:(id)target
          notificationName:(NSString *)notificationName
{
    return [NSString stringWithFormat:@"%d|%@", target, notificationName];
}

@end
