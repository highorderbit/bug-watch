//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"
#import "NewMessageCommentDescription.h"

@interface AddMessageCommentResponseProcessor : AsynchronousResponseProcessor
{
    id messageKey;
    id projectKey;
    NewMessageCommentDescription * description;
    id delegate;

    NSArray * commentKeys;
    NSArray * comments;
    NSArray * authors;
}

@property (nonatomic, copy, readonly) id messageKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, copy, readonly) NewMessageCommentDescription *
    description;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithMessageKey:(id)aMessageKey
                   projectKey:(id)aProjectKey
                  description:(NewMessageCommentDescription *)aDescription
                     delegate:(id)aDelegate;

- (id)initWithMessageKey:(id)aMessageKey
              projectKey:(id)aProjectKey
             description:(NewMessageCommentDescription *)aDescription
                delegate:(id)aDelegate;

@end
