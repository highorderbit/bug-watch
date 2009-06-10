//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchAllTicketsResponseProcessor.h"
#import "BugWatchObjectBuilder.h"

@interface FetchAllTicketsResponseProcessor ()

@property (nonatomic, assign) id delegate;

@end

@implementation FetchAllTicketsResponseProcessor

@synthesize delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                  delegate:(id)aDelegate
{
    return [[[[self class] alloc]
        initWithBuilder:aBuilder delegate:aDelegate] autorelease];
}

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder])
        self.delegate = aDelegate;

    return self;
}

#pragma mark Processing responses

- (void)processResponse:(NSData *)xml
{
    NSArray * ticketNumbers = [self.objectBuilder parseTicketNumbers:xml];
    NSArray * tickets = [self.objectBuilder parseTickets:xml];
    NSArray * metadata = [self.objectBuilder parseTicketMetaData:xml];
    NSArray * milestoneIds = [self.objectBuilder parseTicketMilestoneIds:xml];
    NSArray * projectIds = [self.objectBuilder parseTicketProjectIds:xml];
    NSArray * userIds = [self.objectBuilder parseUserIds:xml];
    NSArray * creatorIds = [self.objectBuilder parseCreatorIds:xml];

    SEL sel =
        @selector(tickets:fetchedForAllProjectsWithMetadata:ticketNumbers:\
             milestoneIds:projectIds:userIds:creatorIds:);

    [self invokeSelector:sel withTarget:delegate args:tickets, metadata,
        ticketNumbers, milestoneIds, projectIds, userIds, creatorIds, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchTicketsForAllProjects:);
    [self invokeSelector:sel withTarget:delegate args:errors, nil];
}

@end
