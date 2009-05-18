//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDetailsDataSource.h"
#import "LighthouseApiService.h"
#import "TicketCache.h"
#import "MilestoneCache.h"
#import "Milestone.h"

@implementation MilestoneDetailsDataSource

@synthesize delegate;

- (void)dealloc
{
    [service release];

    [ticketCache release];
    [milestoneCache release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithLighthouseApiService:(LighthouseApiService *)aService
                       ticketCache:(TicketCache *)aTicketCache
                    milestoneCache:(MilestoneCache *)aMilestoneCache
{
    if (self = [super init]) {
        service = [aService retain];
        service.delegate = self;

        ticketCache = [aTicketCache retain];
        milestoneCache = [aMilestoneCache retain];
    }

    return self;
}

- (BOOL)fetchIfNecessary:(NSString *)queryString milestoneKey:(id)milestoneKey
    projectKey:(id)projectKey
{
    [delegate fetchDidBegin];
    [service searchTicketsForProject:projectKey withSearchString:queryString
        object:milestoneKey token:@"6998f7ed27ced7a323b256d83bd7fec98167b1b3"];

    return YES;
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)tickets:(NSArray *)tickets fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString object:(id)object
    metadata:(NSArray *)metadata ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds userIds:(NSArray *)userIds
    creatorIds:(NSArray *)creatorIds
{
    // TEMPORARY
    // this will eventually be read from a user cache of some sort
    NSDictionary * users =
        [NSDictionary dictionaryWithObjectsAndKeys:
        @"Doug Kurth", [NSNumber numberWithInt:50190],
        @"John A. Debay", [NSNumber numberWithInt:50209],
        nil];

    NSMutableDictionary * matchingTickets =
        [NSMutableDictionary dictionaryWithCapacity:tickets.count];
    NSMutableDictionary * matchingMetadata =
        [NSMutableDictionary dictionaryWithCapacity:metadata.count];
    NSMutableDictionary * matchingUserIds =
        [NSMutableDictionary dictionaryWithCapacity:userIds.count];
    NSMutableDictionary * matchingCreatorIds =
        [NSMutableDictionary dictionaryWithCapacity:creatorIds.count];

    for (NSInteger i = 0, count = ticketNumbers.count; i < count; ++i) {
        NSNumber * number = [ticketNumbers objectAtIndex:i];
        NSUInteger numberAsInt = [number integerValue];
        Ticket * ticket = [tickets objectAtIndex:i];
        TicketMetaData * metaData = [metadata objectAtIndex:i];
        id milestoneId = [milestoneIds objectAtIndex:i];
        id userId = [userIds objectAtIndex:i];
        id creatorId = [creatorIds objectAtIndex:i];

        [ticketCache setTicket:ticket forNumber:numberAsInt];
        [ticketCache setMetaData:metaData forNumber:numberAsInt];

        if (userId)
            [ticketCache setAssignedToKey:userId forNumber:numberAsInt];
        if (milestoneId)
            [ticketCache setMilestoneKey:milestoneId forNumber:numberAsInt];
        if (creatorId)
            [ticketCache setCreatedByKey:creatorId forNumber:numberAsInt];

        if ([object isEqual:milestoneId]) {
            [matchingTickets setObject:ticket forKey:number];
            [matchingMetadata setObject:metaData forKey:number];

            id user = [users objectForKey:userId];
            id creator = [users objectForKey:creatorId];
            [matchingUserIds setObject:user forKey:number];
            [matchingCreatorIds setObject:creator forKey:number];
        }
    }

    Milestone * milestone = [milestoneCache milestoneForKey:object];

    [delegate tickets:matchingTickets fetchedForProject:projectKey
        searchString:searchString metadata:matchingMetadata milestone:milestone
        userIds:matchingUserIds creatorIds:matchingCreatorIds];

    [delegate fetchDidEnd];
}

- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString error:(NSError *)error
{
    NSLog(@"Failed to search for milestone details: '%@', '%@', '%@'.",
        projectKey, searchString, error);

    [delegate failedToSearchTicketsForProject:projectKey
        searchString:searchString error:error];

    [delegate fetchDidEnd];
}

@end
