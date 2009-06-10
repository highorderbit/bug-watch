//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchProjectsResponseProcessor.h"
#import "LighthouseApiService.h"  // for notification names

@interface FetchProjectsResponseProcessor ()

@property (nonatomic, assign) id delegate;

@end

@implementation FetchProjectsResponseProcessor

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
    NSArray * projects = [self.objectBuilder parseProjects:xml];
    NSArray * projectKeys = [self.objectBuilder parseProjectKeys:xml];

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
