//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessors.h"

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

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                projectKey:(id)aProjectKey
               description:(NewMessageDescription *)aDescription
                  delegate:(id)aDelegate;

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           projectKey:(id)aProjectKey
          description:(NewMessageDescription *)aDescription
             delegate:(id)aDelegate;

@end
