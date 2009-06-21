//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDataSource.h"
#import "LighthouseApiService.h"
#import "MilestoneCache.h"
#import "ProjectUpdatePublisher.h"

@interface MilestoneDataSource ()

- (void)updateProjects:(NSArray *)someProjects keys:(NSArray *)someProjectKeys;
- (void)updateDelegateWithCacheUsingSelector:(SEL)sel;

@property (nonatomic, retain) LighthouseApiService * service;
@property (nonatomic, retain) MilestoneCache * cache;

@end

@implementation MilestoneDataSource

@synthesize delegate, service, cache;

- (void)dealloc
{
    [service release];
    [cache release];

    [projectUpdater release];

    [super dealloc];
}

#pragma mark Initialization

- (id)initWithLighthouseApiService:(LighthouseApiService *)aService
                    milestoneCache:(MilestoneCache *)aMilestoneCache
{
    if (self = [super init]) {
        self.service = aService;
        service.delegate = self;

        self.cache = aMilestoneCache;

        projectUpdater = [[ProjectUpdatePublisher alloc]
            initWithListener:self action:@selector(allProjectsPublished:keys:)];

        projectsNeedUpdating = YES;
        milestonesNeedUpdating = YES;

        pendingFetches = 0;
    }

    return self;
}

#pragma mark Refreshing the list of milestones

- (BOOL)fetchMilestonesIfNecessary
{
    SEL sel =
        @selector(currentMilestonesForAllProjects:milestoneKeys:projectKeys:);
    [self updateDelegateWithCacheUsingSelector:sel];

    if (projectsNeedUpdating || milestonesNeedUpdating) {
        [delegate fetchDidBegin];

        if (projectsNeedUpdating) {
            [service fetchAllProjects];
            ++pendingFetches;
        }

        if (milestonesNeedUpdating) {
            [service fetchMilestonesForAllProjects];
            ++pendingFetches;
        }
    }

    return projectsNeedUpdating || milestonesNeedUpdating;
}

- (void)refreshMilestones
{
    projectsNeedUpdating = milestonesNeedUpdating = YES;
    [self fetchMilestonesIfNecessary];
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones
                           milestoneIds:(NSArray *)milestoneIds
                             projectIds:(NSArray *)projectIds
{
    NSLog(@"Retrieved %u milestones:\n%@.", milestones.count, milestones);

    NSSet * uniqueProjectIds = [NSSet setWithArray:projectIds];
    for (NSNumber * pid in uniqueProjectIds)
        [cache removeMilestonesForProjectKey:pid];

    for (NSInteger i = 0, count = milestones.count; i < count; ++i) {
        Milestone * milestone = [milestones objectAtIndex:i];
        NSNumber * milestoneId = [milestoneIds objectAtIndex:i];
        NSNumber * projectId = [projectIds objectAtIndex:i];

        [cache setMilestone:milestone forKey:milestoneId];
        [cache setProjectKey:projectId forKey:milestoneId];
    }

    milestonesNeedUpdating = NO;

    SEL sel =
        @selector(currentMilestonesForAllProjects:milestoneKeys:projectKeys:);
    [self updateDelegateWithCacheUsingSelector:sel];

    if (--pendingFetches == 0)
        [delegate fetchDidEnd];
}

- (void)failedToFetchMilestonesForAllProjects:(NSArray *)errors
{
    NSLog(@"Failed to retrieve milestones for project: %@.", errors);

    milestonesNeedUpdating = NO;  // should this be set to YES?

    [delegate fetchFailedWithErrors:errors];

    if (--pendingFetches == 0)
        [delegate fetchDidEnd];
}

- (void)fetchedAllProjects:(NSArray *)projects
               projectKeys:(NSArray *)keys
{
    [self updateProjects:projects keys:keys];

    if (--pendingFetches == 0)
        [delegate fetchDidEnd];
}

- (void)failedToFetchAllProjects:(NSArray *)errors
{
    NSLog(@"Failed to retrieve milestones for project: %@.", errors);

    projectsNeedUpdating = NO;  // should this be set to YES?

    [delegate fetchFailedWithErrors:errors];

    if (--pendingFetches == 0)
        [delegate fetchDidEnd];
}

#pragma mark Receiving system notifications

- (void)allProjectsPublished:(NSArray *)projects
                        keys:(NSArray *)keys
{
    [self updateProjects:projects keys:keys];
}

#pragma mark Helper methods

- (void)updateProjects:(NSArray *)projects keys:(NSArray *)keys
{
    [delegate currentProjects:projects projectKeys:keys];
    projectsNeedUpdating = NO;
}

- (void)updateDelegateWithCacheUsingSelector:(SEL)sel
{
    NSDictionary * allMilestones = [cache allMilestones];
    NSMutableArray * milestones =
        [NSMutableArray arrayWithCapacity:allMilestones.count];
    NSMutableArray * milestoneKeys =
        [NSMutableArray arrayWithCapacity:allMilestones.count];
    NSMutableArray * projKeys =
        [NSMutableArray arrayWithCapacity:allMilestones.count];

    for (id milestoneKey in allMilestones) {
        [milestoneKeys addObject:milestoneKey];
        [milestones addObject:[cache milestoneForKey:milestoneKey]];
        [projKeys addObject:[cache projectKeyForKey:milestoneKey]];
    }

    // HACK: casting the delegate as an NSObject so we can use NSInvocation
    NSMethodSignature * sig = [((id) delegate) methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:delegate];
    [inv setSelector:sel];
    [inv setArgument:&milestones atIndex:2];
    [inv setArgument:&milestoneKeys atIndex:3];
    [inv setArgument:&projKeys atIndex:4];

    [inv invoke];
}

@end
