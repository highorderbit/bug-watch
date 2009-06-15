//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDetailsDataSource.h"
#import "LighthouseApiService.h"
#import "TicketCache.h"
#import "MilestoneCache.h"
#import "Milestone.h"
#import "LighthouseKey.h"
#import "NSObject+RuntimeAdditions.h"

@interface MilestoneDetailsDataSource ()

- (void)provideDelegateCachedDataForTicketNumbers:(NSArray *)ticketNumbers
                                     searchString:(NSString *)searchString;

+ (id)keyForSearchString:(NSString *)searchString
            milestoneKey:(id)aMilestoneKey
              projectKey:(id)aProjectKey;

@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) id milestoneKey;

@end

@implementation MilestoneDetailsDataSource

@synthesize delegate;
@synthesize projectKey, milestoneKey;

- (void)dealloc
{
    [service release];

    [ticketCache release];
    [milestoneCache release];

    [projectKey release];
    [milestoneKey release];

    [cachedQueries release];

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

        cachedQueries = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (BOOL)fetchIfNecessary:(NSString *)searchString milestoneKey:(id)aMilestoneKey
    projectKey:(id)aProjectKey
{
    self.projectKey = aProjectKey;
    self.milestoneKey = aMilestoneKey;

    NSString * queryKey = [[self class] keyForSearchString:searchString
                                              milestoneKey:milestoneKey
                                                projectKey:projectKey];
    NSArray * ticketNumbers = [cachedQueries objectForKey:queryKey];

    if (ticketNumbers)
        [self provideDelegateCachedDataForTicketNumbers:ticketNumbers
                                           searchString:searchString];
    else {
        [delegate fetchDidBegin];
        [service searchTicketsForProject:self.projectKey
                        withSearchString:searchString
                                    page:1
                                  object:milestoneKey];
    }

    return !!ticketNumbers;
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)tickets:(NSArray *)tickets fetchedForProject:(id)aProjectKey
    searchString:(NSString *)searchString object:(id)object
    metadata:(NSArray *)metadata ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds projectIds:(NSArray *)projectIds
    userIds:(NSArray *)userIds creatorIds:(NSArray *)creatorIds
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
        NSNumber * projectId = [projectIds objectAtIndex:i];
        NSUInteger projectIdAsInt = [projectId integerValue];
        NSNumber * number = [ticketNumbers objectAtIndex:i];
        NSUInteger numberAsInt = [number integerValue];
        LighthouseKey * ticketKey =
            [[[LighthouseKey alloc]
            initWithProjectKey:projectIdAsInt key:numberAsInt]
            autorelease];
        Ticket * ticket = [tickets objectAtIndex:i];
        TicketMetaData * metaData = [metadata objectAtIndex:i];
        id milestoneId = [milestoneIds objectAtIndex:i];
        id userId = [userIds objectAtIndex:i];
        id creatorId = [creatorIds objectAtIndex:i];

        [ticketCache setTicket:ticket forKey:ticketKey];
        [ticketCache setMetaData:metaData forKey:ticketKey];

        if (userId)
            [ticketCache setAssignedToKey:userId forKey:ticketKey];
        if (milestoneId)
            [ticketCache setMilestoneKey:milestoneId forKey:ticketKey];
        if (creatorId)
            [ticketCache setCreatedByKey:creatorId forKey:ticketKey];

        if ([object isEqual:milestoneId]) {
            [matchingTickets setObject:ticket forKey:ticketKey];
            [matchingMetadata setObject:metaData forKey:ticketKey];

            id user = [users objectForKey:userId];
            id creator = [users objectForKey:creatorId];
            [matchingUserIds setObject:user forKey:ticketKey];
            [matchingCreatorIds setObject:creator forKey:ticketKey];
        }
    }

    self.milestoneKey = object;
    Milestone * milestone = [milestoneCache milestoneForKey:self.milestoneKey];

    [delegate tickets:matchingTickets fetchedForProject:aProjectKey
        searchString:searchString metadata:matchingMetadata milestone:milestone
        userIds:matchingUserIds creatorIds:matchingCreatorIds];

    // remember the results of this query
    NSString * queryKey = [[self class] keyForSearchString:searchString
                                              milestoneKey:milestoneKey
                                                projectKey:projectKey];
    [cachedQueries setObject:matchingTickets.allKeys forKey:queryKey];

    [delegate fetchDidEnd];
}

- (void)failedToSearchTicketsForProject:(id)aProjectKey
                           searchString:(NSString *)searchString
                                 errors:(NSArray *)errors
{
    NSLog(@"Failed to search for milestone details: '%@', '%@', '%@'.",
        aProjectKey, searchString, errors);

    [delegate failedToSearchTicketsForProject:aProjectKey
        searchString:searchString errors:errors];

    [delegate fetchDidEnd];
}

#pragma mark Helper functions

- (void)provideDelegateCachedDataForTicketNumbers:(NSArray *)ticketNumbers
                                     searchString:(NSString *)searchString
{
    // TEMPORARY
    // this will eventually be read from a user cache of some sort
    NSDictionary * allUsers =
        [NSDictionary dictionaryWithObjectsAndKeys:
        @"Doug Kurth", [NSNumber numberWithInt:50190],
        @"John A. Debay", [NSNumber numberWithInt:50209],
        nil];

    NSMutableDictionary * tickets = [NSMutableDictionary dictionary];
    NSMutableDictionary * metadatas = [NSMutableDictionary dictionary];
    NSMutableDictionary * users = [NSMutableDictionary dictionary];
    NSMutableDictionary * creators = [NSMutableDictionary dictionary];

    for (LighthouseKey * ticketKey in ticketNumbers) {
        Ticket * ticket = [ticketCache ticketForKey:ticketKey];
        TicketMetaData * metadata = [ticketCache metaDataForKey:ticketKey];
        id creatorKey = [ticketCache createdByKeyForKey:ticketKey];
        id userKey = [ticketCache assignedToKeyForKey:ticketKey];

        [tickets setObject:ticket forKey:ticketKey];
        [metadatas setObject:metadata forKey:ticketKey];
        [users setObject:[allUsers objectForKey:userKey] forKey:ticketKey];
        [creators
            setObject:[allUsers objectForKey:creatorKey] forKey:ticketKey];
    }

    Milestone * milestone = [milestoneCache milestoneForKey:self.milestoneKey];

    [delegate tickets:tickets fetchedForProject:self.projectKey
        searchString:searchString metadata:metadatas milestone:milestone
        userIds:users creatorIds:creators];
}

+ (id)keyForSearchString:(NSString *)searchString
            milestoneKey:(id)aMilestoneKey
              projectKey:(id)aProjectKey
{
    return [NSString stringWithFormat:@"%@|%@|%@", searchString, aMilestoneKey,
        aProjectKey];
}

@end
