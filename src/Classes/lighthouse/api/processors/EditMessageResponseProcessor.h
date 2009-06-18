//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@class UpdateMessageDescription;

@interface EditMessageResponseProcessor : ResponseProcessor
{
    id messageKey;
    id projectKey;
    UpdateMessageDescription * description;
    id delegate;
}

@property (nonatomic, copy, readonly) id messageKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, copy, readonly) UpdateMessageDescription * description;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithMessageKey:(id)aMessageKey
                   projectKey:(id)aProjectKey
                  description:(UpdateMessageDescription *)aDescription
                     delegate:(id)aDelegate;

- (id)initWithMessageKey:(id)aMessageKey
              projectKey:(id)aProjectKey
             description:(UpdateMessageDescription *)aDescription
                delegate:(id)aDelegate;

@end
