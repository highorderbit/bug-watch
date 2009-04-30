//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiceResponseDispatcher : NSObject
{
    NSMutableDictionary * invocations;
}

- (id)init;

- (void)request:(NSURLRequest *)request isHandledBySelector:(SEL)selector
     target:(id)target object:(id<NSObject>)object;

- (void)dispatchResponse:(id)response toRequest:(NSURLRequest *)request;

@end
