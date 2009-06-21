//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchTicketDetailsResponseProcessor.h"
#import "Ticket.h"
#import "TicketMetaData.h"

@interface FetchTicketDetailsResponseProcessor ()

@property (nonatomic, copy) id ticketKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) Ticket * ticket;
@property (nonatomic, retain) TicketMetaData * ticketMetadata;
@property (nonatomic, retain) NSArray * ticketComments;
@property (nonatomic, retain) NSArray * commentAuthors;

@end

@implementation FetchTicketDetailsResponseProcessor

@synthesize ticketKey, projectKey, delegate;
@synthesize ticket, ticketMetadata, ticketComments, commentAuthors;

+ (id)processorWithTicketKey:(id)aTicketKey
                  projectKey:(id)aProjectKey
                    delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithTicketKey:aTicketKey
                                          projectKey:aProjectKey
                                            delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.ticketKey = nil;
    self.projectKey = nil;
    self.delegate = nil;

    self.ticket = nil;
    self.ticketMetadata = nil;
    self.ticketComments = nil;
    self.commentAuthors = nil;

    [super dealloc];
}

- (id)initWithTicketKey:(id)aTicketKey
             projectKey:(id)aProjectKey
               delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.ticketKey = aTicketKey;
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}

#pragma mark Processing responses

- (void)processResponseAsynchronously:(NSData *)xml
{
    self.ticket = [[self.objectBuilder parseTickets:xml] lastObject];
    self.ticketMetadata =
        [[self.objectBuilder parseTicketMetaData:xml] lastObject];

    self.ticketComments = [self.objectBuilder parseTicketComments:xml];
    self.commentAuthors = [self.objectBuilder parseTicketCommentAuthors:xml];
}

- (void)asynchronousProcessorFinished
{
    SEL sel =
        @selector(details:authors:ticket:metadata:fetchedForTicket:inProject:);
    [self invokeSelector:sel withTarget:delegate args:ticketComments,
        commentAuthors, ticket, ticketMetadata, ticketKey, projectKey, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchTicketDetailsForTicket:inProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey, projectKey,
        errors, nil];
}

@end
