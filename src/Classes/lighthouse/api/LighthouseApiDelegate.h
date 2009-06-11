//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseApiDelegate

- (void)request:(id)requestId succeededWithResponse:(NSData *)response;
- (void)request:(id)requestId failedWithError:(NSError *)error;

@end
