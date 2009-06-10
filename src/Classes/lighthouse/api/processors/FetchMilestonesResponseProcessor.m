//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchMilestonesResponseProcessor.h"
#import "LighthouseApiService.h"  // for notification names

@interface FetchMilestonesResponseProcessor ()

@property (nonatomic, assign) id delegate;

@end

@implementation FetchMilestonesResponseProcessor

@synthesize delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                  delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder])
        self.delegate = aDelegate;

    return self;
}

- (void)processResponse:(NSData *)xml
{
    NSArray * milestones = [self.objectBuilder parseMilestones:xml];
    NSArray * milestoneIds = [self.objectBuilder parseMilestoneIds:xml];
    NSArray * projectIds = [self.objectBuilder parseMilestoneProjectIds:xml];

    SEL sel =
        @selector(milestonesFetchedForAllProjects:milestoneIds:projectIds:);
    [self invokeSelector:sel withTarget:delegate args:milestones, milestoneIds,
       projectIds, nil];

    // post general notification
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSDictionary * userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
        milestones, @"milestones",
        milestoneIds, @"milestoneKeys",
        projectIds, @"projectKeys",
        nil];
    NSString * notificationName =
        [LighthouseApiService milestonesReceivedForAllProjectsNotificationName];
    [nc postNotificationName:notificationName
                      object:self
                    userInfo:userInfo];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchMilestonesForAllProjects:);
    [self invokeSelector:sel withTarget:delegate args:errors, nil];
}

@end
