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

+ (NSString *)descriptionKey;
+ (NSString *)messageKey;
+ (NSString *)creationDateKey;

+ (NSString *)tagsKey;
+ (NSString *)stateKey;
+ (NSString *)lastModifiedDateKey;

@end

@implementation TicketPersistenceStore

- (void)dealloc
{
    [ticketCache release];
    [plistName release];
    [super dealloc];
}

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    plistName:(NSString *)aPlistName
{
    if (self = [super init]) {
        ticketCache = [aTicketCache retain];
        plistName = [aPlistName copy];
    }

    return self;
}

#pragma mark PersistenceStore implementation

- (void)load
{
    NSDictionary * dict = [PlistUtils getDictionaryFromPlist:plistName];

    NSDictionary * ticketDict =
        [dict objectForKey:[[self class] ticketDictKey]];
    NSDictionary * metaDataDict =
        [dict objectForKey:[[self class] metaDataDictKey]];

    for (NSNumber * number in [ticketDict allKeys]) {
        NSDictionary * ticketFieldsDict = [ticketDict objectForKey:number];
        Ticket * ticket = [[self class] ticketFromDictionary:ticketFieldsDict];
        [ticketCache setTicket:ticket forNumber:[number intValue]];
        
        NSDictionary * metaDataFieldsDict =
            [metaDataDict objectForKey:number];
        TicketMetaData * metaData =
            [[self class] metaDataFromDictionary:metaDataFieldsDict];
        [ticketCache setMetaData:metaData forNumber:[number intValue]];
    }
}

- (void)save
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableDictionary * ticketDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * metaDataDict = [NSMutableDictionary dictionary];
    
    NSDictionary * allTickets = [ticketCache allTickets];
    for (NSNumber * number in [allTickets allKeys]) {
        Ticket * ticket = [allTickets objectForKey:number];
        NSDictionary * ticketFieldDict =
            [[self class] dictionaryFromTicket:ticket];
        [ticketDict setObject:ticketFieldDict forKey:number];
    }
    
    NSDictionary * allMetaData = [ticketCache allMetaData];
    for (NSNumber * number in [allMetaData allKeys]) {
        TicketMetaData * metaData = [allMetaData objectForKey:number];
        NSDictionary * metaDataFieldDict =
            [[self class] dictionaryFromMetaData:metaData];
        [metaDataDict setObject:metaDataFieldDict forKey:number];
    }

    [dict setObject:ticketDict forKey:[[self class] ticketDictKey]];
    [dict setObject:metaDataDict forKey:[[self class] metaDataDictKey]];

    [PlistUtils saveDictionary:dict toPlist:plistName];
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
