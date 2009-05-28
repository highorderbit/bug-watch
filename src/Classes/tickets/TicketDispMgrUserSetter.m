//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDispMgrUserSetter.h"
#import "User.h"

@implementation TicketDispMgrUserSetter

- (void)dealloc
{
    [ticketDisplayMgr release];
    [super dealloc];
}

- (id)initWithTicketDisplayMgr:(TicketDisplayMgr *)aTicketDisplayMgr
{
    if (self = [super init])
        ticketDisplayMgr = [aTicketDisplayMgr retain];

    return self;
}

- (void)fetchedAllUsers:(NSDictionary *)users
{
    NSLog(@"Setting users on ticket display manager...");
    NSLog(@"Users: %@", users);
    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
    for (id key in [users allKeys]) {
        User * user = [users objectForKey:key];
        [userDict setObject:user.name forKey:key];
    }

    ticketDisplayMgr.userDict = userDict;
}

@end
