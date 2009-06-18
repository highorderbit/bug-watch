//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"

@class TicketDataCollector;

@interface FetchAllTicketsResponseProcessor : AsynchronousResponseProcessor
{
    id delegate;

    TicketDataCollector * collector;
}

@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithDelegate:(id)aDelegate;
- (id)initWithDelegate:(id)aDelegate;

@end
