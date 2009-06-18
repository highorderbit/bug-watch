//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@class NewTicketDescription;

@interface CreateTicketResponseProcessor : ResponseProcessor
{
    NewTicketDescription * description;
    id projectKey;
    id delegate;
}

@property (nonatomic, copy, readonly) NewTicketDescription * description;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, assign, readonly) id delegate;

#pragma mark Instantiation and Initialization

+ (id)processorWithDescription:(NewTicketDescription *)aDescription
                    projectKey:(id)aProjectKey
                      delegate:(id)aDelegate;
- (id)initWithDescription:(NewTicketDescription *)aDescription
               projectKey:(id)aProjectKey
                 delegate:(id)aDelegate;

@end
