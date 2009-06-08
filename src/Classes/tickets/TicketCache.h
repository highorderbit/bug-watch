//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import "TicketMetaData.h"
#import "TicketComment.h"

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

- (void)setTicket:(Ticket *)ticket forKey:(id)key;
- (Ticket *)ticketForKey:(id)key;
- (NSDictionary *)allTickets;

- (void)setMetaData:(TicketMetaData *)someMetaData forKey:(id)key;
- (TicketMetaData *)metaDataForKey:(id)key;
- (NSDictionary *)allMetaData;

- (void)setCreatedByKey:(id)key forKey:(id)key;
- (id)createdByKeyForKey:(id)key;
- (NSDictionary *)allCreatedByKeys;

- (void)setAssignedToKey:(id)key forKey:(id)key;
- (id)assignedToKeyForKey:(id)key;
- (NSDictionary *)allAssignedToKeys;

- (void)setMilestoneKey:(id)key forKey:(id)key;
- (id)milestoneKeyForKey:(id)key;
- (NSDictionary *)allMilestoneKeys;

- (void)setCommentKeys:(NSArray *)keys forKey:(id)key;
- (NSArray *)commentKeysForKey:(id)key;
- (NSDictionary *)allCommentKeys;

- (void)merge:(TicketCache *)aTicketCache;

@end
