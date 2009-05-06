//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import "TicketMetaData.h"
#import "TicketComment.h"

@interface TicketCache : NSObject
{
    NSMutableDictionary * tickets;
    NSMutableDictionary * metaData;

    NSMutableDictionary * createdByDict;    
    NSMutableDictionary * assignedToDict;
    NSMutableDictionary * milestoneDict;
}

- (void)setTicket:(Ticket *)ticket forNumber:(NSUInteger)number;
- (Ticket *)ticketForNumber:(NSUInteger)number;
- (NSDictionary *)allTickets;

- (void)setMetaData:(TicketMetaData *)someMetaData forNumber:(NSUInteger)number;
- (TicketMetaData *)metaDataForNumber:(NSUInteger)number;
- (NSDictionary *)allMetaData;

- (void)setCreatedByKey:(id)key forNumber:(NSUInteger)number;
- (id)createdByKeyForNumber:(NSUInteger)number;
- (NSDictionary *)allCreatedByKeys;

- (void)setAssignedToKey:(id)key forNumber:(NSUInteger)number;
- (id)assignedToKeyForNumber:(NSUInteger)number;
- (NSDictionary *)allAssignedToKeys;

- (void)setMilestoneKey:(id)key forNumber:(NSUInteger)number;
- (id)milestoneKeyForNumber:(NSUInteger)number;
- (NSDictionary *)allMilestoneKeys;

- (void)setCommentKeys:(NSArray *)keys forNumber:(NSUInteger)number;
- (NSArray *)commentKeysForNumber:(NSUInteger)number;

- (void)setComment:(TicketComment *)comment forKey:(id)key;
- (TicketComment *)commentForKey:(id)key;

@end
