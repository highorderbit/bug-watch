//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDisplayMgr.h"

@interface TicketDispMgrProjectSetter : NSObject
{
    TicketDisplayMgr * ticketDisplayMgr;
}

- (id)initWithTicketDisplayMgr:(TicketDisplayMgr *)aTicketDisplayMgr;
- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;

@end
