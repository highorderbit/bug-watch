//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseApiDelegate

#pragma mark Retrieving tickets

- (void)tickets:(NSData *)xml fetchedForAllProjects:(NSString *)token;
- (void)failedToFetchTicketsForAllProjects:(NSString *)token
                                     error:(NSError *)error;

@end
