//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BugWatchObjectBuilder.h"

@interface ResponseProcessor : NSObject
{
  @private
    BugWatchObjectBuilder * objectBuilder;
}

@property (nonatomic, retain, readonly) BugWatchObjectBuilder * objectBuilder;

#pragma mark Initialization

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder;

#pragma mark Processing responses

- (void)process:(NSData *)xml;
- (void)processError:(NSError *)error;

#pragma mark Protected interface implemented by subclasses

- (void)processResponse:(NSData *)response;
- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml;

#pragma mark Helper methods provided to subclasses

- (BOOL)invokeSelector:(SEL)selector withTarget:(id)target
    args:(id)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

@end
