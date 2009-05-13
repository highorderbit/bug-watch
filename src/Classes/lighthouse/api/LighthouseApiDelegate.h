//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseApiDelegate

#pragma mark Tickets

- (void)tickets:(NSData *)xml fetchedForAllProjectsWithToken:(NSString *)token;
- (void)failedToFetchTicketsForAllProjects:(NSString *)token
                                     error:(NSError *)error;

- (void)searchResults:(NSData *)xml
    fetchedForAllProjectsWithSearchString:(NSString *)searchString
    token:(NSString *)token;
- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    token:(NSString *)token error:(NSError *)error;

#pragma mark Ticket bins

- (void)ticketBins:(NSData *)xml
    fetchedForProject:(NSUInteger)projectId token:(NSString *)token;
- (void)failedToFetchTicketBinsForProject:(NSUInteger)projectId
    token:(NSString *)token error:(NSError *)error;

#pragma mark Milestones

- (void)milestones:(NSData *)xml
    fetchedForAllProjectsWithToken:(NSString *)token;
- (void)failedToFetchMilestonesForAllProjects:(NSString *)token
    error:(NSError *)error;

@end
