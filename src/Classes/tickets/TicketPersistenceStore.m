//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketPersistenceStore.h"
#import "Ticket.h"
#import "PListUtils.h"
#import "TicketMetaData.h"

@interface TicketPersistenceStore (Private)

+ (NSDictionary *)dictionaryFromTicket:(Ticket *)ticket;
+ (Ticket *)ticketFromDictionary:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryFromMetaData:(TicketMetaData *)metaData;
+ (TicketMetaData *)metaDataFromDictionary:(NSDictionary *)dict;

+ (NSString *)ticketDictKey;
+ (NSString *)metaDataDictKey;
+ (NSString *)createdByDictKey;
+ (NSString *)assignedToDictKey;
+ (NSString *)milestoneDictKey;

+ (NSString *)descriptionKey;
+ (NSString *)messageKey;
+ (NSString *)creationDateKey;

+ (NSString *)tagsKey;
+ (NSString *)stateKey;
+ (NSString *)lastModifiedDateKey;

@end

@implementation TicketPersistenceStore

- (TicketCache *)loadWithPlist:(NSString *)plist
{
    TicketCache * ticketCache = [[[TicketCache alloc] init] autorelease];

    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plist];

    NSDictionary * ticketDict =
        [dict objectForKey:[[self class] ticketDictKey]];
    NSDictionary * metaDataDict =
        [dict objectForKey:[[self class] metaDataDictKey]];
    NSDictionary * createdByDict =
        [dict objectForKey:[[self class] createdByDictKey]];
    NSDictionary * assignedToDict =
        [dict objectForKey:[[self class] assignedToDictKey]];
    NSDictionary * milestoneDict =
        [dict objectForKey:[[self class] milestoneDictKey]];

    for (NSString * numberAsString in [ticketDict allKeys]) {
        NSUInteger number = [numberAsString integerValue];
        NSDictionary * ticketFieldsDict =
            [ticketDict objectForKey:numberAsString];
        Ticket * ticket = [[self class] ticketFromDictionary:ticketFieldsDict];
        [ticketCache setTicket:ticket forNumber:number];
        
        NSDictionary * metaDataFieldsDict =
            [metaDataDict objectForKey:numberAsString];
        TicketMetaData * metaData =
            [[self class] metaDataFromDictionary:metaDataFieldsDict];
        [ticketCache setMetaData:metaData forNumber:number];
        
        id createdByKey = [createdByDict objectForKey:numberAsString];
        [ticketCache setCreatedByKey:createdByKey forNumber:number];

        id assignedToKey = [assignedToDict objectForKey:numberAsString];
        [ticketCache setAssignedToKey:assignedToKey forNumber:number];

        id milestoneKey = [milestoneDict objectForKey:numberAsString];
        [ticketCache setMilestoneKey:milestoneKey forNumber:number];
    }
    
    return ticketCache;
}

- (void)saveTicketCache:(TicketCache *)ticketCache toPlist:(NSString *)plist
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableDictionary * ticketDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * metaDataDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * createdByDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * assignedToDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * milestoneDict = [NSMutableDictionary dictionary];
    
    NSDictionary * allTickets = [ticketCache allTickets];
    for (NSNumber * number in [allTickets allKeys]) {
        Ticket * ticket = [allTickets objectForKey:number];
        NSDictionary * ticketFieldDict =
            [[self class] dictionaryFromTicket:ticket];
        [ticketDict setObject:ticketFieldDict forKey:[number description]];
    }
    
    NSDictionary * allMetaData = [ticketCache allMetaData];
    for (NSNumber * number in [allMetaData allKeys]) {
        TicketMetaData * metaData = [allMetaData objectForKey:number];
        NSDictionary * metaDataFieldDict =
            [[self class] dictionaryFromMetaData:metaData];
        [metaDataDict setObject:metaDataFieldDict forKey:[number description]];
    }
    
    NSDictionary * allCreatedByKeys = [ticketCache allCreatedByKeys];
    for (NSNumber * number in [allCreatedByKeys allKeys]) {
        id createdByKey = [allCreatedByKeys objectForKey:number];
        [createdByDict setObject:createdByKey forKey:[number description]];
    }
    
    NSDictionary * allAssignedToKeys = [ticketCache allAssignedToKeys];
    for (NSNumber * number in [allAssignedToKeys allKeys]) {
        id assignedToKey = [allAssignedToKeys objectForKey:number];
        [assignedToDict setObject:assignedToKey forKey:[number description]];
    }

    NSDictionary * allMilestoneKeys = [ticketCache allMilestoneKeys];
    for (NSNumber * number in [allMilestoneKeys allKeys]) {
        id milestoneKey = [allMilestoneKeys objectForKey:number];
        [milestoneDict setObject:milestoneKey forKey:[number description]];
    }

    [dict setObject:ticketDict forKey:[[self class] ticketDictKey]];
    [dict setObject:metaDataDict forKey:[[self class] metaDataDictKey]];
    [dict setObject:createdByDict forKey:[[self class] createdByDictKey]];
    [dict setObject:assignedToDict forKey:[[self class] assignedToDictKey]];
    [dict setObject:milestoneDict forKey:[[self class] milestoneDictKey]];

    NSLog(@"Ticket cache: %@", dict);
    [PlistUtils saveDictionary:dict toPlist:plist];
}

#pragma mark Data conversion methods

+ (NSDictionary *)dictionaryFromTicket:(Ticket *)ticket
{
    NSMutableDictionary * dict;
    if (ticket) {
        dict = [NSMutableDictionary dictionary];
    
        if (ticket.description)
            [dict setObject:ticket.description
                forKey:[[self class] descriptionKey]];
        if (ticket.message)
            [dict setObject:ticket.message forKey:[[self class] messageKey]];
        if (ticket.creationDate)
            [dict setObject:ticket.creationDate
                forKey:[[self class] creationDateKey]];
    } else
        dict = nil;
    
    return dict;
}

+ (Ticket *)ticketFromDictionary:(NSDictionary *)dict
{
    Ticket * ticket;
    if (dict) {
        NSString * description =
            [dict objectForKey:[[self class] descriptionKey]];
        NSString * message = [dict objectForKey:[[self class] messageKey]];
        NSDate * creationDate =
            [dict objectForKey:[[self class] creationDateKey]];

        ticket =
            [[[Ticket alloc]
            initWithDescription:description message:message
            creationDate:creationDate]
            autorelease];
    } else
        ticket = nil;
    
    return ticket;
}

+ (NSDictionary *)dictionaryFromMetaData:(TicketMetaData *)metaData
{
    NSMutableDictionary * dict;
    if (metaData) {
        dict = [NSMutableDictionary dictionary];
    
        if (metaData.tags)
            [dict setObject:metaData.tags forKey:[[self class] tagsKey]];
        [dict setObject:[NSNumber numberWithInt:metaData.state]
            forKey:[[self class] stateKey]];
        if (metaData.lastModifiedDate)
            [dict setObject:metaData.lastModifiedDate
                forKey:[[self class] lastModifiedDateKey]];
    } else
        dict = nil;
    
    return dict;
}

+ (TicketMetaData *)metaDataFromDictionary:(NSDictionary *)dict
{
    TicketMetaData * metaData;
    if (dict) {
        NSString * tags =
            [dict objectForKey:[[self class] tagsKey]];
        NSUInteger state =
            [(NSNumber *)[dict objectForKey:[[self class] stateKey]]
            intValue];
        NSDate * lastModifiedDate =
            [dict objectForKey:[[self class] lastModifiedDateKey]];

        metaData =
            [[[TicketMetaData alloc]
            initWithTags:tags state:state lastModifiedDate:lastModifiedDate]
            autorelease];
    } else
        metaData = nil;
    
    return metaData;
}

#pragma mark Dictionary keys

+ (NSString *)ticketDictKey
{
    return @"ticketDict";
}

+ (NSString *)metaDataDictKey
{
    return @"metaDataDict";
}

+ (NSString *)createdByDictKey
{
    return @"createdByDict";
}

+ (NSString *)assignedToDictKey
{
    return @"assignedToDict";
}

+ (NSString *)milestoneDictKey
{
    return @"milestoneDict";
}

+ (NSString *)descriptionKey
{
    return @"description";
}

+ (NSString *)messageKey
{
    return @"message";
}

+ (NSString *)creationDateKey
{
    return @"creationDate";
}

+ (NSString *)tagsKey
{
    return @"tags";
}

+ (NSString *)stateKey
{
    return @"state";
}

+ (NSString *)lastModifiedDateKey
{
    return @"lastModifiedDate";
}

@end
