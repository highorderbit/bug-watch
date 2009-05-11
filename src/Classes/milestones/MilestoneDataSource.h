//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiServiceDelegate.h"
#import "MilestoneDataSourceDelegate.h"

@class LighthouseApiService;

@interface MilestoneDataSource : NSObject <LighthouseApiServiceDelegate>
{
    id<MilestoneDataSourceDelegate> delegate;

    LighthouseApiService * service;

    NSArray * cache;  // temporary implementation

    BOOL needsUpdating;
}

@property (nonatomic, assign) id<MilestoneDataSourceDelegate> delegate;

#pragma mark Initialization

- (id)initWithLighthouseApiService:(LighthouseApiService *)service;

#pragma mark Retrieve current milestones

- (NSArray *)currentMilestones;

#pragma mark Refreshing the list of milestones

- (BOOL)fetchMilestonesIfNecessary;
- (void)refreshMilestones;

@end
