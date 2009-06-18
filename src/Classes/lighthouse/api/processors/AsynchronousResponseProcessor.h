//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcessor.h"

@class AsynchronousInvocation;

@interface AsynchronousResponseProcessor : ResponseProcessor
{
    AsynchronousInvocation * asynchronousInvocation;
}

+ (id)processor;
- (id)init;

@end
