//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@interface DeleteTicketResponseProcessor : ResponseProcessor
{
    id ticketKey;
    id projectKey;
    id delegate;
}

@property (nonatomic, copy, readonly) id ticketKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                 ticketKey:(id)aTicketKey
                projectKey:(id)aProjectKey
                  delegate:(id)aDelegate;

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
            ticketKey:(id)aTicketKey
           projectKey:(id)aProjectKey
             delegate:(id)aDelegate;
@end
