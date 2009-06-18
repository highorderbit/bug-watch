//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@class NewMessageDescription;

@interface CreateMessageResponseProcessor : ResponseProcessor
{
    id projectKey;
    NewMessageDescription * description;
    id delegate;
}

@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, copy, readonly) NewMessageDescription * description;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithProjectKey:(id)aProjectKey
                  description:(NewMessageDescription *)aDescription
                     delegate:(id)aDelegate;

- (id)initWithProjectKey:(id)aProjectKey
             description:(NewMessageDescription *)aDescription
                delegate:(id)aDelegate;

@end
