//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDispMgrMilestoneSetter.h"
#import "Milestone.h"

@implementation TicketDispMgrMilestoneSetter

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

- (void)milestonesReceivedForAllProjects:(NSArray *)milestones
    milestoneKeys:(NSArray *)milestoneKeys projectKeys:(NSArray *)projectKeys
{
    NSLog(@"Setting milestones on ticket display manager...");
    NSLog(@"Milestones: %@", milestones);
    NSMutableDictionary * milestoneDict = [NSMutableDictionary dictionary];
    for (int i = 0; i < [milestoneKeys count]; i++) {
        id milestoneKey = [milestoneKeys objectAtIndex:i];
        Milestone * milestone = [milestones objectAtIndex:i];
        NSString * milestoneName = milestone.name;
        [milestoneDict setObject:milestoneName forKey:milestoneKey];
    }

    ticketDisplayMgr.milestoneDict = milestoneDict;
}

@end
