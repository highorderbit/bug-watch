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

    NSArray * commentKeys;
    NSArray * comments;
    NSArray * authors;
}

@property (nonatomic, copy, readonly) id messageKey;
@property (nonatomic, copy, readonly) id projectKey;
@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithMessageKey:(id)aMessageKey
                   projectKey:(id)aProjectKey
                     delegate:(id)aDelegate;

- (id)initWithMessageKey:(id)aMessageKey
              projectKey:(id)aProjectKey
                delegate:(id)aDelegate;

@end
