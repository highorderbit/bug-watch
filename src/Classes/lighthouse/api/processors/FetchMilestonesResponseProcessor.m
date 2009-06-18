//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchMilestonesResponseProcessor.h"
#import "LighthouseApiService.h"  // for notification names

@interface FetchMilestonesResponseProcessor ()

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSArray * milestones;
@property (nonatomic, retain) NSArray * milestoneIds;
@property (nonatomic, retain) NSArray * projectIds;

@end

@implementation FetchMilestonesResponseProcessor

@synthesize delegate;
@synthesize milestones, milestoneIds, projectIds;

+ (id)processorWithDelegate:(id)aDelegate
{
    return [[[[self class] alloc] initWithDelegate:aDelegate] autorelease];
}

- (void)dealloc
{
    self.delegate = nil;

    self.milestones = nil;
    self.milestoneIds = nil;
    self.projectIds = nil;

    [super dealloc];
}

- (id)initWithDelegate:(id)aDelegate
{
    if (self = [super init])
        self.delegate = aDelegate;

    return self;
}

- (void)processResponseAsynchronously:(NSData *)xml
{
    self.milestones = [self.objectBuilder parseMilestones:xml];
    self.milestoneIds = [self.objectBuilder parseMilestoneIds:xml];
    self.projectIds = [self.objectBuilder parseMilestoneProjectIds:xml];
}

- (void)asynchronousProcessorFinished
{
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
