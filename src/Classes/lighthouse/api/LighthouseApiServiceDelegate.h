//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseApiServiceDelegate <NSObject>

#pragma mark Fetching tickets

@optional

- (void)tickets:(NSArray *)tickets
    fetchedForAllProjectsWithMetadata:(NSArray *)metadata
    ticketNumbers:(NSArray *)ticketNumbers;
- (void)failedToFetchTicketsForAllProjects:(NSError *)error;

@optional

#pragma mark Fetching milestones

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones;
- (void)failedToFetchMilestonesForAllProjects:(NSError *)error;

@end
