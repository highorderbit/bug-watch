//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchTicketDetailsResponseProcessor.h"

@interface FetchTicketDetailsResponseProcessor ()

@property (nonatomic, copy) id ticketKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSArray * ticketComments;
@property (nonatomic, retain) NSArray * authors;

@end

@implementation FetchTicketDetailsResponseProcessor

@synthesize ticketKey, projectKey, delegate;
@synthesize ticketComments, authors;

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

    self.ticketComments = nil;
    self.authors = nil;

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
    self.ticketComments = [self.objectBuilder parseTicketComments:xml];
    self.authors = [self.objectBuilder parseTicketCommentAuthors:xml];
}

- (void)asynchronousProcessorFinished
{
    SEL sel = @selector(details:authors:fetchedForTicket:inProject:);
    [self invokeSelector:sel withTarget:delegate args:ticketComments,
        authors, ticketKey, projectKey, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchTicketDetailsForTicket:inProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey, projectKey,
        errors, nil];
}

@end
