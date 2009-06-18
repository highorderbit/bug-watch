//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"

@interface FetchMessagesResponseProcessor : AsynchronousResponseProcessor
{
    id projectKey;
    id delegate;

    NSArray * messages;
    NSArray * messageKeys;
    NSArray * authorKeys;
}

@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithProjectKey:(id)aProjectKey
                     delegate:(id)aDelegate;

- (id)initWithProjectKey:(id)aProjectKey
                delegate:(id)aDelegate;

@end
