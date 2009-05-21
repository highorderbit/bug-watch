//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "MilestoneDataSource.h"
#import "LighthouseApiService.h"
#import "MilestoneCache.h"

@interface MilestoneDataSource ()

- (void)updateDelegateWithCacheUsingSelector:(SEL)sel;

@property (nonatomic, retain) MilestoneCache * cache;

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
                    milestoneCache:(MilestoneCache *)aMilestoneCache
{
    if (self = [super init]) {
        service = [aService retain];
        service.delegate = self;

        self.cache = aMilestoneCache;

        needsUpdating = YES;
    }

    return self;
}

#pragma mark Refreshing the list of milestones

- (BOOL)fetchMilestonesIfNecessary
{
    SEL sel =
        @selector(currentMilestonesForAllProjects:milestoneKeys:projectKeys:);
    [self updateDelegateWithCacheUsingSelector:sel];

    if (needsUpdating) {
        [delegate milestoneFetchDidBegin];
        [service
            fetchMilestonesForAllProjects:
            @"6998f7ed27ced7a323b256d83bd7fec98167b1b3"];
    }

    return needsUpdating;
}

- (void)refreshMilestones
{
    needsUpdating = YES;
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

    needsUpdating = NO;

    SEL sel =
        @selector(milestonesFetchedForAllProjects:milestoneKeys:projectKeys:);
    [self updateDelegateWithCacheUsingSelector:sel];

    [delegate milestoneFetchDidEnd];
}

- (void)failedToFetchMilestonesForAllProjects:(NSError *)error
{
    NSLog(@"Failed to retrieve milestones for project: %@.", error);

    needsUpdating = NO;

    [delegate failedToFetchMilestonesForAllProjects:error];
    [delegate milestoneFetchDidEnd];
}

#pragma mark Helper methods

- (void)updateDelegateWithCacheUsingSelector:(SEL)sel
{
    NSDictionary * allMilestones = [cache allMilestones];
    NSMutableArray * milestones =
        [NSMutableArray arrayWithCapacity:allMilestones.count];
    NSMutableArray * milestoneKeys =
        [NSMutableArray arrayWithCapacity:allMilestones.count];
    NSMutableArray * projectKeys =
        [NSMutableArray arrayWithCapacity:allMilestones.count];

    for (id milestoneKey in allMilestones) {
        [milestoneKeys addObject:milestoneKey];
        [milestones addObject:[cache milestoneForKey:milestoneKey]];
        [projectKeys addObject:[cache projectKeyForKey:milestoneKey]];
    }

    // HACK: casting the delegate as an NSObject so we can use NSInvocation
    NSMethodSignature * sig = [((id) delegate) methodSignatureForSelector:sel];
    NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];

    [inv setTarget:delegate];
    [inv setSelector:sel];
    [inv setArgument:&milestones atIndex:2];
    [inv setArgument:&milestoneKeys atIndex:3];
    [inv setArgument:&projectKeys atIndex:4];

    [inv invoke];
}

@end
