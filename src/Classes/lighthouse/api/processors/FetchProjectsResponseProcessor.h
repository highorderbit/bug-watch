//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"

@interface FetchProjectsResponseProcessor : AsynchronousResponseProcessor
{
    id delegate;

    NSArray * projects;
    NSArray * projectKeys;
}

@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                  delegate:(id)aDelegate;

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
             delegate:(id)aDelegate;

@end
