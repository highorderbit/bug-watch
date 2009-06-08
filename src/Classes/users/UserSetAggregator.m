//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserSetAggregator.h"
#import "User.h"

@implementation UserSetAggregator

@synthesize users;

- (void)dealloc
{
    [service release];
    [token release];
    [super dealloc];
}

- (id)initWithApiService:(LighthouseApiService *)aService
    token:(NSString *)aToken
{
    if (self = [super init]) {
        service = [aService retain];
        token = [aToken retain];
    }

    return self;
}

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys
{
    NSLog(@"Projects fetched for user aggregator.");
    self.users = [NSMutableDictionary dictionary];
    outstandingRequests = [keys count];

    for (id key in keys)
        [service fetchAllUsersForProject:key token:token];
}

- (void)allUsers:(NSDictionary *)projectUsers fetchedForProject:(id)projectKey
{
    outstandingRequests--;
    [self.users addEntriesFromDictionary:projectUsers];
    if (outstandingRequests == 0) {
        NSArray * userKeys = [self.users allKeys];
        NSMutableArray * userArray = [NSMutableArray array];

        for (int i = 0; i < [userKeys count]; i++) {
            id key = [userKeys objectAtIndex:i];
            User * user = [self.users objectForKey:key];
            [userArray insertObject:user atIndex:i];
        }

        // post general notification
        NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
        NSDictionary * userInfo =
            [NSDictionary dictionaryWithObjectsAndKeys:
            userArray, @"users",
            userKeys, @"userKeys",
            nil];
        NSString * notificationName =
            [[self class] allUsersReceivedNotificationName];
        [nc postNotificationName:notificationName object:self
            userInfo:userInfo];
    }
}

+ (NSString *)allUsersReceivedNotificationName
{
    return @"BugWatchAllUsersReceivedNotification";
}

@end
