//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"
#import "NewMessageCommentDescription.h"

@interface AddMessageCommentResponseProcessor : ResponseProcessor
{
    id messageKey;
    id projectKey;
    NewMessageCommentDescription * description;
    id delegate;
}

@property (nonatomic, copy, readonly) id messageKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, copy, readonly) NewMessageCommentDescription *
    description;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                messageKey:(id)aMessageKey
                projectKey:(id)aProjectKey
               description:(NewMessageCommentDescription *)aDescription
                  delegate:(id)aDelegate;

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           messageKey:(id)aMessageKey
           projectKey:(id)aProjectKey
          description:(NewMessageCommentDescription *)aDescription
             delegate:(id)aDelegate;

@end