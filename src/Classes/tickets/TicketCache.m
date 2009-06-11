//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketCache.h"

@implementation TicketCache

@synthesize query, numPages;

- (void)dealloc
{
    [query release];
    [tickets release];
    [metaData release];
    [createdByDict release];
    [assignedToDict release];
    [milestoneDict release];
    [commentDict release];

    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        tickets = [[NSMutableDictionary dictionary] retain];
        metaData = [[NSMutableDictionary dictionary] retain];
        createdByDict = [[NSMutableDictionary dictionary] retain];
        assignedToDict = [[NSMutableDictionary dictionary] retain];
        milestoneDict = [[NSMutableDictionary dictionary] retain];
        commentDict = [[NSMutableDictionary dictionary] retain];
    }
    
    return self;
}

- (void)setTicket:(Ticket *)ticket forKey:(TicketKey *)key
{
    [tickets setObject:ticket forKey:key];
}

- (Ticket *)ticketForKey:(TicketKey *)key
{
    return [[[tickets objectForKey:key] copy] autorelease];
}

- (NSDictionary *)allTickets
{
    return [[tickets copy] autorelease];
}

- (void)setMetaData:(TicketMetaData *)someMetaData forKey:(TicketKey *)key
{
    [metaData setObject:someMetaData forKey:key];
}

- (TicketMetaData *)metaDataForKey:(TicketKey *)key
{
    return [[[metaData objectForKey:key] copy] autorelease];
}

- (NSDictionary *)allMetaData
{
    return [[metaData copy] autorelease];
}

- (void)setCreatedByKey:(id)createdByKey forKey:(TicketKey *)key
{
    [createdByDict setObject:createdByKey forKey:key];
}

- (id)createdByKeyForKey:(TicketKey *)key
{
    return [createdByDict objectForKey:key];
}

- (NSDictionary *)allCreatedByKeys
{
    return [[createdByDict copy] autorelease];
}

- (void)setAssignedToKey:(id)assignedToKey forKey:(TicketKey *)key
{
    [assignedToDict setObject:assignedToKey forKey:key];
}

- (id)assignedToKeyForKey:(TicketKey *)key
{
    return [assignedToDict objectForKey:key];
}

- (NSDictionary *)allAssignedToKeys
{
    return [[assignedToDict copy] autorelease];
}

- (void)setMilestoneKey:(id)milestoneKey forKey:(TicketKey *)key
{
    [milestoneDict setObject:milestoneKey forKey:key];
}

- (id)milestoneKeyForKey:(TicketKey *)key
{
    return [milestoneDict objectForKey:key];
}

- (NSDictionary *)allMilestoneKeys
{
    return [[milestoneDict copy] autorelease];
}

- (void)setCommentKeys:(NSArray *)keys forKey:(TicketKey *)key
{
    [commentDict setObject:keys forKey:key];
}

- (NSArray *)commentKeysForKey:(TicketKey *)key
{
    return [commentDict objectForKey:key];
}

- (NSDictionary *)allCommentKeys
{
    return [[commentDict copy] autorelease];
}

- (void)merge:(TicketCache *)aTicketCache
{
    [tickets addEntriesFromDictionary:aTicketCache.allTickets];
    [metaData addEntriesFromDictionary:aTicketCache.allMetaData];
    [createdByDict addEntriesFromDictionary:aTicketCache.allCreatedByKeys];
    [assignedToDict addEntriesFromDictionary:aTicketCache.allAssignedToKeys];
    [milestoneDict addEntriesFromDictionary:aTicketCache.allMilestoneKeys];
    [commentDict addEntriesFromDictionary:aTicketCache.allCommentKeys];
    self.numPages = aTicketCache.numPages;
}

- (NSString *)description
{
    return [tickets description];
}

@end
