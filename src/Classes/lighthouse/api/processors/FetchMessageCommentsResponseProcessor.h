//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@interface FetchMessageCommentsResponseProcessor : ResponseProcessor
{
    id messageKey;
    id projectKey;
    id delegate;
}

@property (nonatomic, copy, readonly) id messageKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                messageKey:(id)aMessageKey
                projectKey:(id)aProjectKey
                  delegate:(id)aDelegate;

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           messageKey:(id)aMessageKey
           projectKey:(id)aProjectKey
             delegate:(id)aDelegate;

@end
