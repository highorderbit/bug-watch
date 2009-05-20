//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDisplayMgr.h"

@interface TicketDispMgrMilestoneSetter : NSObject
{
    TicketDisplayMgr * ticketDisplayMgr;
}

- (id)initWithTicketDisplayMgr:(TicketDisplayMgr *)aTicketDisplayMgr;

- (void)milestonesReceivedForAllProjects:(NSArray *)milestones
    milestoneKeys:(NSArray *)milestoneKeys projectKeys:(NSArray *)projectKeys;

@end
