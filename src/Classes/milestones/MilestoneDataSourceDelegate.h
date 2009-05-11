//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MilestoneDataSourceDelegate

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones;
- (void)failedToFetchMilestonesForAllProjects:(NSError *)error;

@end
