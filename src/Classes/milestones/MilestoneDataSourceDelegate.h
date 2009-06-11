//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MilestoneDataSourceDelegate

- (void)fetchDidBegin;
- (void)fetchDidEnd;
- (void)fetchFailedWithErrors:(NSArray *)errors;

- (void)currentMilestonesForAllProjects:(NSArray *)milestones
                          milestoneKeys:(NSArray *)milestoneKeys
                            projectKeys:(NSArray *)projectKeys;

- (void)currentProjects:(NSArray *)projects projectKeys:(NSArray *)projectKeys;

@end
