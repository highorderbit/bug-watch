//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchAllTicketsResponseProcessor.h"
#import "BugWatchObjectBuilder.h"
#import "TicketDataWrapper.h"

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
    NSArray * wrappers = [self.objectBuilder parseTicketDataWrappers:xml];
    TicketDataCollector * collector =
        [[TicketDataCollector alloc] initWithDataWrappers:wrappers];

    SEL sel =
        @selector(tickets:fetchedForAllProjectsWithMetadata:ticketNumbers:\
             milestoneIds:projectIds:userIds:creatorIds:);

    [self invokeSelector:sel withTarget:delegate args:collector.tickets,
        collector.metadata, collector.ticketNumbers, collector.milestoneIds,
        collector.projectIds, collector.userIds, collector.creatorIds, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchTicketsForAllProjects:);
    [self invokeSelector:sel withTarget:delegate args:errors, nil];
}

@end
