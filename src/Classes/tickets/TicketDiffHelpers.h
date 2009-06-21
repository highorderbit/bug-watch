//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TicketAttribute {
    kTicketAttributeState,
    kTicketAttributeAssignedTo,
    kTicketAttributeMilestone,
    kTicketAttributeTags
};

typedef NSInteger TicketAttribute;

static const NSInteger UNKNOWN_TICKET_ATTRIBUTE = -1;

typedef NSDictionary TicketDiff;

@interface TicketDiffHelpers : NSObject

+ (NSString *)descriptionFromDiffs:(NSArray *)diffs atIndex:(NSUInteger)index
    withUserNames:(NSDictionary *)usernames
    milestoneNames:(NSDictionary *)milestoneNames;

+ (NSInteger)ticketAttributeFromString:(NSString *)string;

@end
