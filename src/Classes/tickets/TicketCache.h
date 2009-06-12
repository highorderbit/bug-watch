//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import "TicketMetaData.h"
#import "TicketComment.h"
#import "TicketKey.h"

@interface TicketCache : NSObject
{
    NSString * query;
    NSUInteger numPages;

    NSMutableDictionary * tickets;
    NSMutableDictionary * metaData;

    NSMutableDictionary * createdByDict;    
    NSMutableDictionary * assignedToDict;
    NSMutableDictionary * milestoneDict;
    NSMutableDictionary * commentDict;
}

@property (nonatomic, copy) NSString * query;
@property (nonatomic, assign) NSUInteger numPages;

- (void)setTicket:(Ticket *)ticket forKey:(TicketKey *)key;
- (Ticket *)ticketForKey:(TicketKey *)key;
- (NSDictionary *)allTickets;

- (void)setMetaData:(TicketMetaData *)someMetaData forKey:(TicketKey *)key;
- (TicketMetaData *)metaDataForKey:(TicketKey *)key;
- (NSDictionary *)allMetaData;

- (void)setCreatedByKey:(id)key forKey:(TicketKey *)key;
- (id)createdByKeyForKey:(TicketKey *)key;
- (NSDictionary *)allCreatedByKeys;

- (void)setAssignedToKey:(id)key forKey:(TicketKey *)key;
- (id)assignedToKeyForKey:(TicketKey *)key;
- (NSDictionary *)allAssignedToKeys;

- (void)setMilestoneKey:(id)key forKey:(TicketKey *)key;
- (id)milestoneKeyForKey:(TicketKey *)key;
- (NSDictionary *)allMilestoneKeys;

- (void)setCommentKeys:(NSArray *)keys forKey:(TicketKey *)key;
- (NSArray *)commentKeysForKey:(TicketKey *)key;
- (NSDictionary *)allCommentKeys;

- (void)merge:(TicketCache *)aTicketCache;

@end
