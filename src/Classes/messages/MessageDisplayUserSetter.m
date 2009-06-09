//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDisplayUserSetter.h"
#import "User.h"

@implementation MessageDisplayUserSetter

- (void)dealloc
{
    [messageDisplayMgr release];
    [super dealloc];
}

- (id)initWithMessageDisplayMgr:(MessageDisplayMgr *)aMessageDisplayMgr
{
    if (self = [super init])
        messageDisplayMgr = [aMessageDisplayMgr retain];

    return self;
}

- (void)fetchedAllUsers:(NSDictionary *)users
{
    NSLog(@"Setting users on message display manager...");
    NSLog(@"Users: %@", users);
    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
    for (id key in [users allKeys]) {
        User * user = [users objectForKey:key];
        [userDict setObject:user.name forKey:key];
    }

    messageDisplayMgr.userDict = userDict;
}

@end
