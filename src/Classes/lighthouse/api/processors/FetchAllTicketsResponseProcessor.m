//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchAllTicketsResponseProcessor.h"
#import "BugWatchObjectBuilder.h"
#import "TicketDataWrapper.h"

@interface FetchAllTicketsResponseProcessor ()

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) TicketDataCollector * collector;

@end

@implementation FetchAllTicketsResponseProcessor

@synthesize delegate;
@synthesize collector;

+ (id)processorWithDelegate:(id)aDelegate
{
    return [[[[self class] alloc] initWithDelegate:aDelegate] autorelease];
}

- (void)dealloc
{
    self.delegate = nil;
    self.collector = nil;
    [super dealloc];
}

- (id)initWithDelegate:(id)aDelegate
{
    if (self = [super init])
        self.delegate = aDelegate;

    return self;
}

#pragma mark Processing responses

- (void)processResponseAsynchronously:(NSData *)xml
{
    NSArray * wrappers = [self.objectBuilder parseTicketDataWrappers:xml];
    self.collector =
        [[TicketDataCollector alloc] initWithDataWrappers:wrappers];
}

- (void)asynchronousProcessorFinished
{
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
