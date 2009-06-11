//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractUpdatePublisher : NSObject
{
  @private
    NSInvocation * invocation;
}

#pragma mark Initialization

- (id)initWithListener:(id)listener action:(SEL)action;

#pragma mark Notifying listeners -- to be called by subclasses

- (void)notifyListener:(NSArray *)args;

@end