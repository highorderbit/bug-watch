//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDataSource.h"
#import "TicketCache.h"
#import "TicketKey.h"

@implementation TicketDataSource

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [service release];
    [super dealloc];
}

-(id)initWithService:(LighthouseApiService *)aService
{
    if (self = [super init])
        service = [aService retain];

    return self;
}

- (void)fetchTicketsWithQuery:(NSString *)aFilterString
{
    // TEMPORARY
    static NSString * token = @"6998f7ed27ced7a323b256d83bd7fec98167b1b3";
    [service searchTicketsForAllProjects:aFilterString token:token];
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)tickets:(NSArray *)tickets
    fetchedForSearchString:(NSString *)searchString
    metadata:(NSArray *)someMetaData ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds userIds:(NSArray *)userIds
    creatorIds:(NSArray *)creatorIds
{
    NSLog(@"Received tickets: %@", tickets);
    
    // create ticket cache
    TicketCache * ticketCache = [[TicketCache alloc] init];
    for (int i = 0; i < [ticketNumbers count]; i++) {
        NSNumber * number = [ticketNumbers objectAtIndex:i];
        NSUInteger numberAsInt = [((NSNumber *)number) intValue];
        id projectId = nil;
        id ticketKey =
            [[[TicketKey alloc]
            initWithProjectKey:projectId ticketNumber:numberAsInt] autorelease];

        Ticket * ticket = [tickets objectAtIndex:i];
        TicketMetaData * metaData = [someMetaData objectAtIndex:i];
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
    }

    [delegate receivedTicketsFromDataSource:ticketCache];
}

- (void)failedToFetchTicketsForAllProjects:(NSError *)response
{}

@end
