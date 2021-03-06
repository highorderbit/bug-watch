//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiServiceDelegate.h"
#import "MilestoneDataSourceDelegate.h"

@class MilestoneCache;
@class LighthouseApiService;
@class ProjectUpdatePublisher;

@interface MilestoneDataSource : NSObject <LighthouseApiServiceDelegate>
{
    id<MilestoneDataSourceDelegate> delegate;

    LighthouseApiService * service;
    MilestoneCache * cache;

    BOOL projectsNeedUpdating;
    BOOL milestonesNeedUpdating;

    NSUInteger pendingFetches;

    ProjectUpdatePublisher * projectUpdater;
}

@property (nonatomic, assign) id<MilestoneDataSourceDelegate> delegate;

#pragma mark Initialization

- (id)initWithLighthouseApiService:(LighthouseApiService *)aService
                    milestoneCache:(MilestoneCache *)aMilsetoneCache;

#pragma mark Refreshing the list of milestones

- (BOOL)fetchMilestonesIfNecessary;
- (void)refreshMilestones;

@end
