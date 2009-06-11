//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchTicketDetailsResponseProcessor.h"

@interface FetchTicketDetailsResponseProcessor ()

@property (nonatomic, copy) id ticketKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@end

@implementation FetchTicketDetailsResponseProcessor

@synthesize ticketKey, projectKey, delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                 ticketKey:(id)aTicketKey
                projectKey:(id)aProjectKey
                  delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                         ticketKey:aTicketKey
                                        projectKey:aProjectKey
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.ticketKey = nil;
    self.projectKey = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
            ticketKey:(id)aTicketKey
           projectKey:(id)aProjectKey
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.ticketKey = aTicketKey;
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}

#pragma mark Processing responses

- (void)processResponse:(NSData *)xml
{
    NSArray * ticketComments = [self.objectBuilder parseTicketComments:xml];
    NSArray * authors = [self.objectBuilder parseTicketCommentAuthors:xml];

    SEL sel = @selector(details:authors:fetchedForTicket:inProject:);
    [self invokeSelector:sel withTarget:delegate args:ticketComments,
        authors, ticketKey, projectKey, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel =
        @selector(failedToFetchTicketDetailsForTicket:inProject:token:errors:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey, projectKey,
        errors, nil];
}

@end