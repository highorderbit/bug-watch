//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"
#import "TicketMetaData.h"
#import "TicketComment.h"
#import "LighthouseKey.h"

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

- (void)setTicket:(Ticket *)ticket forKey:(LighthouseKey *)key;
- (Ticket *)ticketForKey:(LighthouseKey *)key;
- (NSDictionary *)allTickets;

- (void)setMetaData:(TicketMetaData *)someMetaData forKey:(LighthouseKey *)key;
- (TicketMetaData *)metaDataForKey:(LighthouseKey *)key;
- (NSDictionary *)allMetaData;

- (void)setCreatedByKey:(id)key forKey:(LighthouseKey *)key;
- (id)createdByKeyForKey:(LighthouseKey *)key;
- (NSDictionary *)allCreatedByKeys;

- (void)setAssignedToKey:(id)key forKey:(LighthouseKey *)key;
- (id)assignedToKeyForKey:(LighthouseKey *)key;
- (NSDictionary *)allAssignedToKeys;

- (void)setMilestoneKey:(id)key forKey:(LighthouseKey *)key;
- (id)milestoneKeyForKey:(LighthouseKey *)key;
- (NSDictionary *)allMilestoneKeys;

- (void)setCommentKeys:(NSArray *)keys forKey:(LighthouseKey *)key;
- (NSArray *)commentKeysForKey:(LighthouseKey *)key;
- (NSDictionary *)allCommentKeys;

- (void)merge:(TicketCache *)aTicketCache;

@end
