//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketCache.h"

@implementation TicketCache

- (void)dealloc
{
    [tickets release];
    [metaData release];
    [createdByDict release];
    [assignedToDict release];
    [milestoneDict release];
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
    }
    
    return self;
}

- (void)setTicket:(Ticket *)ticket forNumber:(NSUInteger)number
{
    [tickets setObject:ticket forKey:[NSNumber numberWithInt:number]];
}

- (Ticket *)ticketForNumber:(NSUInteger)number
{
    return [[tickets objectForKey:[NSNumber numberWithInt:number]] copy];
}

- (NSDictionary *)allTickets
{
    return [tickets copy];
}

- (void)setMetaData:(TicketMetaData *)someMetaData forNumber:(NSUInteger)number
{
    [metaData setObject:someMetaData forKey:[NSNumber numberWithInt:number]];
}

- (TicketMetaData *)metaDataForNumber:(NSUInteger)number
{
    return [[metaData objectForKey:[NSNumber numberWithInt:number]] copy];
}

- (NSDictionary *)allMetaData
{
    return [metaData copy];
}

- (void)setCreatedByKey:(id)key forNumber:(NSUInteger)number
{
    [createdByDict setObject:key forKey:[NSNumber numberWithInt:number]];
}

- (id)createdByKeyForNumber:(NSUInteger)number
{
    return [createdByDict objectForKey:[NSNumber numberWithInt:number]];
}

- (NSDictionary *)allCreatedByKeys
{
    return [createdByDict copy];
}

- (void)setAssignedToKey:(id)key forNumber:(NSUInteger)number
{
    [assignedToDict setObject:key forKey:[NSNumber numberWithInt:number]];
}

- (id)assignedToKeyForNumber:(NSUInteger)number
{
    return [assignedToDict objectForKey:[NSNumber numberWithInt:number]];
}

- (NSDictionary *)allAssignedToKeys
{
    return [assignedToDict copy];
}

- (void)setMilestoneKey:(id)key forNumber:(NSUInteger)number
{
    [milestoneDict setObject:key forKey:[NSNumber numberWithInt:number]];
}

- (id)milestoneKeyForNumber:(NSUInteger)number
{
    return [milestoneDict objectForKey:[NSNumber numberWithInt:number]];
}

- (NSDictionary *)allMilestoneKeys
{
    return [milestoneDict copy];
}

- (void)setCommentKeys:(NSArray *)keys forNumber:(NSUInteger)number
{}

- (NSArray *)commentKeysForNumber:(NSUInteger)number
{
    return nil;
}

- (void)setComment:(TicketComment *)comment forKey:(id)key
{}

- (TicketComment *)commentForKey:(id)key
{
    return nil;
}

@end
