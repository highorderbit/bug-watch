//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDataSource.h"
#import "LighthouseApiService.h"

@interface MilestoneDataSource ()

@property (nonatomic, copy) NSArray * cache;

@end

@implementation MilestoneDataSource

@synthesize delegate, cache;

- (void)dealloc
{
    [service release];
    [cache release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithLighthouseApiService:(LighthouseApiService *)aService
{
    if (self = [super init]) {
        service = [aService retain];
        service.delegate = self;

        needsUpdating = YES;
    }

    return self;
}

#pragma mark Retrieve current milestones

- (NSArray *)currentMilestones
{
    return cache;
}

#pragma mark Refreshing the list of milestones

- (BOOL)fetchMilestonesIfNecessary
{
    if (needsUpdating)
        [service
            fetchMilestonesForAllProjects:
            @"6998f7ed27ced7a323b256d83bd7fec98167b1b3"];

    return needsUpdating;
}

- (void)refreshMilestones
{
    needsUpdating = YES;
    [self fetchMilestonesIfNecessary];
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones
{
    NSLog(@"Retrieved %u milestones:\n%@.", milestones.count, milestones);

    needsUpdating = NO;
    self.cache = milestones;

    [delegate milestonesFetchedForAllProjects:milestones];
}

- (void)failedToFetchMilestonesForAllProjects:(NSError *)error
{
    NSLog(@"Failed to retrieve milestones for project: %@.", error);

    needsUpdating = NO;

    [delegate failedToFetchMilestonesForAllProjects:error];
}

@end
