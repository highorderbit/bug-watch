//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "SearchAllTicketsResponseProcessor.h"
#import "TicketDataWrapper.h"

@interface SearchAllTicketsResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) NSString * searchString;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, retain) id object;
@property (nonatomic, assign) id<LighthouseApiServiceDelegate> delegate;

@property (nonatomic, retain) TicketDataCollector * collector;

@end

@implementation SearchAllTicketsResponseProcessor

@synthesize projectKey, searchString, page, object, delegate;
@synthesize collector;

+ (id)processorWithSearchString:(NSString *)aSearchString
                           page:(NSUInteger)aPage
                       delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    id obj = [[[self class] alloc] initWithSearchString:aSearchString
                                                   page:aPage
                                               delegate:aDelegate];
    return [obj autorelease];
}

+ (id)processorWithProjectKey:(id)aProjectKey
                 searchString:(NSString *)aSearchString
                         page:(NSUInteger)aPage
                       object:(id)anObject
                     delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    id obj = [[[self class] alloc] initWithProjectKey:aProjectKey
                                         searchString:aSearchString
                                                 page:aPage
                                               object:anObject
                                             delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.projectKey = nil;
    self.searchString = nil;
    self.page = 0;
    self.object = nil;
    self.delegate = nil;
    self.collector = nil;
    [super dealloc];
}

- (id)initWithSearchString:(NSString *)aSearchString
                      page:(NSUInteger)aPage
                  delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    return [self initWithProjectKey:nil
                       searchString:aSearchString
                               page:aPage
                             object:nil
                           delegate:aDelegate];
}

- (id)initWithProjectKey:(id)aProjectKey
            searchString:(NSString *)aSearchString
                    page:(NSUInteger)aPage
                  object:(id)anObject
                delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    if (self = [super init]) {
        self.projectKey = aProjectKey;
        self.searchString = aSearchString;
        self.page = aPage;
        self.object = anObject;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponse_:(NSData *)xml
{
    NSArray * wrappers = [self.objectBuilder parseTicketDataWrappers:xml];

    TicketDataCollector * privateCollector =
        [[TicketDataCollector alloc] initWithDataWrappers:wrappers];

    if (projectKey) {
        SEL sel = @selector(tickets:fetchedForProject:searchString:page:object:\
            metadata:ticketNumbers:milestoneIds:projectIds:userIds:creatorIds:);
        if ([delegate respondsToSelector:sel])
            [delegate tickets:privateCollector.tickets
            fetchedForProject:projectKey
                 searchString:searchString
                         page:page
                       object:object
                     metadata:privateCollector.metadata
                ticketNumbers:privateCollector.ticketNumbers
                 milestoneIds:privateCollector.milestoneIds
                   projectIds:privateCollector.projectIds
                      userIds:privateCollector.userIds
                   creatorIds:privateCollector.creatorIds];
    } else {
        SEL sel = @selector(tickets:fetchedForSearchString:page:metadata:\
            ticketNumbers:milestoneIds:projectIds:userIds:creatorIds:);
        if ([delegate respondsToSelector:sel])
            [delegate tickets:privateCollector.tickets
       fetchedForSearchString:searchString
                         page:page
                     metadata:privateCollector.metadata
                ticketNumbers:privateCollector.ticketNumbers
                 milestoneIds:privateCollector.milestoneIds
                   projectIds:privateCollector.projectIds
                      userIds:privateCollector.userIds
                   creatorIds:privateCollector.creatorIds];
    }

    [privateCollector release];
}

- (void)processResponseAsynchronously:(NSData *)xml
{
    NSArray * wrappers = [self.objectBuilder parseTicketDataWrappers:xml];

    NSLog(@"Beginning object creation.");
    self.collector =
        [[[TicketDataCollector alloc] initWithDataWrappers:wrappers]
        autorelease];
    NSLog(@"Finished object creation.");
}

- (void)asynchronousProcessorFinished
{
    if (projectKey) {
        SEL sel = @selector(tickets:fetchedForProject:searchString:page:object:\
            metadata:ticketNumbers:milestoneIds:projectIds:userIds:creatorIds:);
        if ([delegate respondsToSelector:sel])
            [delegate tickets:collector.tickets
            fetchedForProject:projectKey
                 searchString:searchString
                         page:page
                       object:object
                     metadata:collector.metadata
                ticketNumbers:collector.ticketNumbers
                 milestoneIds:collector.milestoneIds
                   projectIds:collector.projectIds
                      userIds:collector.userIds
                   creatorIds:collector.creatorIds];
    } else {
        SEL sel = @selector(tickets:fetchedForSearchString:page:metadata:\
            ticketNumbers:milestoneIds:projectIds:userIds:creatorIds:);
        if ([delegate respondsToSelector:sel])
            [delegate tickets:collector.tickets
       fetchedForSearchString:searchString
                         page:page
                     metadata:collector.metadata
                ticketNumbers:collector.ticketNumbers
                 milestoneIds:collector.milestoneIds
                   projectIds:collector.projectIds
                      userIds:collector.userIds
                   creatorIds:collector.creatorIds];
    }
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    if (projectKey) {
        SEL sel = @selector(failedToSearchTicketsForProject:searchString:page:\
            object:errors:);
        if ([delegate respondsToSelector:sel])
            [delegate failedToSearchTicketsForProject:projectKey
                                         searchString:searchString
                                                 page:page
                                               object:object
                                               errors:errors];
    } else {
        SEL sel = @selector(failedToSearchTicketsForAllProjects:page:errors:);
        if ([delegate respondsToSelector:sel])
            [delegate failedToSearchTicketsForAllProjects:searchString
                                                     page:page
                                                   errors:errors];
    }
}

@end
