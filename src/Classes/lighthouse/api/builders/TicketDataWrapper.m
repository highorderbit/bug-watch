//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "TicketDataWrapper.h"
#import "Ticket.h"

@implementation TicketDataWrapper

@synthesize ticketNumber;
@synthesize description, creationDate, link;
@synthesize tags, state, lastModifiedDate;
@synthesize milestoneId, projectId, userId, creatorId;

- (void)dealloc
{
    self.ticketNumber;

    self.description;
    self.creationDate;
    self.link;

    self.tags;
    self.state;
    self.lastModifiedDate;

    self.milestoneId;
    self.projectId;
    self.userId;
    self.creatorId;

    [super dealloc];
}

@end

@implementation TicketDataCollector

@synthesize ticketNumbers, tickets, metadata;
@synthesize milestoneIds, projectIds, userIds, creatorIds;

- (void)dealloc
{
    [ticketNumbers release];
    [tickets release];
    [metadata release];
    [milestoneIds release];
    [projectIds release];
    [userIds release];
    [creatorIds release];

    [super dealloc];
}

- (id)initWithDataWrappers:(NSArray *)wrappers
{
    if (self = [super init]) {
        NSInteger n = wrappers.count;

        ticketNumbers = [[NSMutableArray alloc] initWithCapacity:n];
        tickets = [[NSMutableArray alloc] initWithCapacity:n];
        metadata = [[NSMutableArray alloc] initWithCapacity:n];
        milestoneIds = [[NSMutableArray alloc] initWithCapacity:n];
        projectIds = [[NSMutableArray alloc] initWithCapacity:n];
        userIds = [[NSMutableArray alloc] initWithCapacity:n];
        creatorIds = [[NSMutableArray alloc] initWithCapacity:n];

        for (TicketDataWrapper * wrapper in wrappers) {
            [ticketNumbers addObject:wrapper.ticketNumber];

            Ticket * ticket =
                [[Ticket alloc] initWithDescription:wrapper.description
                                       creationDate:wrapper.creationDate
                                               link:wrapper.link];
            [tickets addObject:ticket];
            [ticket release];

            TicketMetaData * metadatum =
                [[TicketMetaData alloc] initWithTags:wrapper.tags
                                               state:wrapper.state
                                    lastModifiedDate:wrapper.lastModifiedDate];
            [metadata addObject:metadatum];
            [metadatum release];

            [milestoneIds addObject:wrapper.milestoneId];
            [projectIds addObject:wrapper.projectId];
            [userIds addObject:wrapper.userId];
            [creatorIds addObject:wrapper.creatorId];
        }
    }

    return self;
}

@end
