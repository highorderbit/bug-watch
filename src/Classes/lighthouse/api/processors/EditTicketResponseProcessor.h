//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@class UpdateTicketDescription;

@interface EditTicketResponseProcessor : ResponseProcessor
{
    UpdateTicketDescription * description;
    id ticketKey;
    id projectKey;
    id delegate;
}

@property (nonatomic, copy, readonly) id ticketKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, copy, readonly) UpdateTicketDescription * description;
@property (nonatomic, assign, readonly) id delegate;

#pragma mark Instantiation and Initialization

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                 ticketKey:(id)aTicketKey
                projectKey:(id)aProjectKey
               description:(UpdateTicketDescription *)aDescription
                  delegate:(id)aDelegate;

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
            ticketKey:(id)aTicketKey
           projectKey:(id)aProjectKey
          description:(UpdateTicketDescription *)aDescription
             delegate:(id)aDelegate;

@end
