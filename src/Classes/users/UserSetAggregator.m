//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "UserSetAggregator.h"

@implementation UserSetAggregator

@synthesize users;

- (void)dealloc
{
    [listener release];
    [service release];
    [token release];
    [super dealloc];
}

- (id)initWithListener:(id)aListener action:(SEL)anAction
    apiService:(LighthouseApiService *)aService token:(NSString *)aToken
{
    if (self = [super init]) {
        listener = [aListener retain];
        action = anAction;
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
        if (outstandingRequests == 0)
            [listener performSelector:action withObject:self.users];
}

@end
