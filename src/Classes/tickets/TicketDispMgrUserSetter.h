//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDisplayMgr.h"

@interface TicketDispMgrUserSetter : NSObject
{
    TicketDisplayMgr * ticketDisplayMgr;
}

- (id)initWithTicketDisplayMgr:(TicketDisplayMgr *)aTicketDisplayMgr;
- (void)fetchedAllUsers:(NSDictionary *)users;

@end
