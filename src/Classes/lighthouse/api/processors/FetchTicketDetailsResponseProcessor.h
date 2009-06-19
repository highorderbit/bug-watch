//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"

@class Ticket, TicketMetaData;

@interface FetchTicketDetailsResponseProcessor : AsynchronousResponseProcessor
{
    id ticketKey;
    id projectKey;
    id delegate;

    Ticket * ticket;
    TicketMetaData * ticketMetadata;
    NSArray * ticketComments;
    NSArray * commentAuthors;
}

@property (nonatomic, copy, readonly) id ticketKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithTicketKey:(id)aTicketKey
                  projectKey:(id)aProjectKey
                    delegate:(id)aDelegate;
- (id)initWithTicketKey:(id)aTicketKey
             projectKey:(id)aProjectKey
               delegate:(id)aDelegate;


@end
