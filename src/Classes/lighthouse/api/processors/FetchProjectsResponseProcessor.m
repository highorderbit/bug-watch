//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchProjectsResponseProcessor.h"
#import "LighthouseApiService.h"  // for notification names

@interface FetchProjectsResponseProcessor ()

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSArray * projects;
@property (nonatomic, retain) NSArray * projectKeys;

@end

@implementation FetchProjectsResponseProcessor

@synthesize delegate;
@synthesize projects, projectKeys;

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
    self.projects = nil;
    self.projectKeys = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder])
        self.delegate = aDelegate;

    return self;
}

- (void)processResponseAsynchronously:(NSData *)xml
{
    self.projects = [self.objectBuilder parseProjects:xml];
    self.projectKeys = [self.objectBuilder parseProjectKeys:xml];
}

- (void)asynchronousProcessorFinished
{
    SEL sel = @selector(fetchedAllProjects:projectKeys:);
    [self
        invokeSelector:sel withTarget:delegate args:projects, projectKeys, nil];

    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSDictionary * userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
        projects, @"projects",
        projectKeys, @"projectKeys",
        nil];
    NSString * notificationName =
        [LighthouseApiService allProjectsReceivedNotificationName];
    [nc postNotificationName:notificationName object:self userInfo:userInfo];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchAllProjects:);
    [self invokeSelector:sel withTarget:delegate args:errors, nil];
}

@end
