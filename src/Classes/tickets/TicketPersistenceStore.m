//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketPersistenceStore.h"
#import "Ticket.h"
#import "PListUtils.h"
#import "TicketMetaData.h"
#import "TicketKey.h"

@interface TicketPersistenceStore (Private)

+ (NSString *)stringFromTicketKey:(TicketKey *)ticketKey;
+ (TicketKey *)ticketKeyFromString:(NSString *)string;
+ (NSString *)ticketKeySplitSequence;

+ (NSDictionary *)dictionaryFromTicket:(Ticket *)ticket;
+ (Ticket *)ticketFromDictionary:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryFromMetaData:(TicketMetaData *)metaData;
+ (TicketMetaData *)metaDataFromDictionary:(NSDictionary *)dict;

+ (NSString *)projectKeyKey;
+ (NSString *)ticketNumberKey;
+ (NSString *)ticketDictKey;
+ (NSString *)metaDataDictKey;
+ (NSString *)createdByDictKey;
+ (NSString *)assignedToDictKey;
+ (NSString *)milestoneDictKey;
+ (NSString *)queryKey;
+ (NSString *)numPagesKey;

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
    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plist];

    if (![dict objectForKey:[[self class] ticketDictKey]]) {
        NSLog(@"Loading 'nil' ticket cache...");
        return nil;
    }

    TicketCache * ticketCache = [[[TicketCache alloc] init] autorelease];

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

    for (NSString * keyAsString in [ticketDict allKeys]) {
        TicketKey * key = [[self class] ticketKeyFromString:keyAsString];
        NSDictionary * ticketFieldsDict =
            [ticketDict objectForKey:keyAsString];
        Ticket * ticket = [[self class] ticketFromDictionary:ticketFieldsDict];
        [ticketCache setTicket:ticket forKey:key];
        
        NSDictionary * metaDataFieldsDict =
            [metaDataDict objectForKey:keyAsString];
        TicketMetaData * metaData =
            [[self class] metaDataFromDictionary:metaDataFieldsDict];
        [ticketCache setMetaData:metaData forKey:key];
        
        id createdByKey = [createdByDict objectForKey:keyAsString];
        [ticketCache setCreatedByKey:createdByKey forKey:key];

        id assignedToKey = [assignedToDict objectForKey:keyAsString];
        [ticketCache setAssignedToKey:assignedToKey forKey:key];

        id milestoneKey = [milestoneDict objectForKey:keyAsString];
        [ticketCache setMilestoneKey:milestoneKey forKey:key];
    }
    
    ticketCache.query = [dict objectForKey:[[self class] queryKey]];
    ticketCache.numPages =
        [[dict objectForKey:[[self class] numPagesKey]] intValue];

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
    for (TicketKey * key in [allTickets allKeys]) {
        Ticket * ticket = [allTickets objectForKey:key];
        NSDictionary * ticketFieldDict =
            [[self class] dictionaryFromTicket:ticket];
        [ticketDict setObject:ticketFieldDict
            forKey:[[self class] stringFromTicketKey:key]];
    }
    
    NSDictionary * allMetaData = [ticketCache allMetaData];
    for (TicketKey * key in [allMetaData allKeys]) {
        TicketMetaData * metaData = [allMetaData objectForKey:key];
        NSDictionary * metaDataFieldDict =
            [[self class] dictionaryFromMetaData:metaData];
        [metaDataDict setObject:metaDataFieldDict
            forKey:[[self class] stringFromTicketKey:key]];
    }
    
    NSDictionary * allCreatedByKeys = [ticketCache allCreatedByKeys];
    for (TicketKey * key in [allCreatedByKeys allKeys]) {
        id createdByKey = [allCreatedByKeys objectForKey:key];
        [createdByDict setObject:createdByKey
            forKey:[[self class] stringFromTicketKey:key]];
    }
    
    NSDictionary * allAssignedToKeys = [ticketCache allAssignedToKeys];
    for (TicketKey * key in [allAssignedToKeys allKeys]) {
        id assignedToKey = [allAssignedToKeys objectForKey:key];
        [assignedToDict setObject:assignedToKey
            forKey:[[self class] stringFromTicketKey:key]];
    }

    NSDictionary * allMilestoneKeys = [ticketCache allMilestoneKeys];
    for (TicketKey * key in [allMilestoneKeys allKeys]) {
        id milestoneKey = [allMilestoneKeys objectForKey:key];
        [milestoneDict setObject:milestoneKey
            forKey:[[self class] stringFromTicketKey:key]];
    }

    [dict setObject:ticketDict forKey:[[self class] ticketDictKey]];
    [dict setObject:metaDataDict forKey:[[self class] metaDataDictKey]];
    [dict setObject:createdByDict forKey:[[self class] createdByDictKey]];
    [dict setObject:assignedToDict forKey:[[self class] assignedToDictKey]];
    [dict setObject:milestoneDict forKey:[[self class] milestoneDictKey]];
    
    if (ticketCache.query)
        [dict setObject:ticketCache.query forKey:[[self class] queryKey]];
    NSNumber * numPages = [NSNumber numberWithInt:ticketCache.numPages];
    [dict setObject:numPages forKey:[[self class] numPagesKey]];

    NSLog(@"Ticket cache: %@", dict);
    [PlistUtils saveDictionary:dict toPlist:plist];
}

#pragma mark Data conversion methods

+ (NSString *)stringFromTicketKey:(TicketKey *)ticketKey
{   
    return ticketKey ?
        [NSString stringWithFormat:@"%d%@%d",
        ticketKey.projectKey,
        [[self class] ticketKeySplitSequence], 
        ticketKey.ticketNumber] :
        nil;
}

+ (TicketKey *)ticketKeyFromString:(NSString *)string
{
    TicketKey * ticketKey;
    if (string) {
        NSArray * components =
            [string componentsSeparatedByString:
            [[self class] ticketKeySplitSequence]];

        NSUInteger projectKey = [[components objectAtIndex:0] integerValue];
        NSUInteger ticketNumber = [[components objectAtIndex:1] integerValue];

        ticketKey =
            [[[TicketKey alloc]
            initWithProjectKey:projectKey ticketNumber:ticketNumber]
            autorelease];
    } else
        ticketKey = nil;
    
    return ticketKey;
}

+ (NSString *)ticketKeySplitSequence
{
    return @"|";
}

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

+ (NSString *)projectKeyKey
{
    return @"projectKey";
}

+ (NSString *)ticketNumberKey
{
    return @"ticketNumber";
}

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

+ (NSString *)queryKey
{
    return @"query";
}

+ (NSString *)numPagesKey
{
    return @"numPages";
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
