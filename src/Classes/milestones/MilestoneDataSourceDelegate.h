//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MilestoneDataSourceDelegate

- (void)currentMilestonesForAllProjects:(NSArray *)milestones
                          milestoneKeys:(NSArray *)milestoneKeys
                            projectKeys:(NSArray *)projectKeys;

- (void)milestoneFetchDidBegin;
- (void)milestoneFetchDidEnd;

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones
                          milestoneKeys:(NSArray *)milestoneKeys
                            projectKeys:(NSArray *)projectKeys;
- (void)failedToFetchMilestonesForAllProjects:(NSError *)error;

@end
