//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsynchronousResponseProcessor.h"

@interface FetchMilestonesResponseProcessor : AsynchronousResponseProcessor
{
    id delegate;

    NSArray * milestones;
    NSArray * milestoneIds;
    NSArray * projectIds;
}

@property (nonatomic, assign, readonly) id delegate;

+ (id)processorWithDelegate:(id)aDelegate;
- (id)initWithDelegate:(id)aDelegate;

@end
