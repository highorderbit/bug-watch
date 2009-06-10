//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchUsersResponseProcessor.h"
#import "LighthouseApiService.h"  // for the notification name

@interface FetchUsersResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@end

@implementation FetchUsersResponseProcessor

@synthesize projectKey, delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                projectKey:(id)aProjectKey
                  delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                        projectKey:aProjectKey
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.projectKey = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           projectKey:(id)aProjectKey
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}


- (void)processResponse:(NSData *)xml
{
    NSArray * users = [self.objectBuilder parseUsers:xml];
    NSArray * userKeys = [self.objectBuilder parseUserKeys:xml];

    NSDictionary * allUsers =
        [NSDictionary dictionaryWithObjects:users forKeys:userKeys];

    SEL sel = @selector(allUsers:fetchedForProject:);
    [self
        invokeSelector:sel withTarget:delegate args:allUsers, projectKey, nil];

    // post general notification
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSDictionary * userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
        allUsers, @"users",
        projectKey, @"projectKey",
        nil];
    NSString * notificationName =
        [LighthouseApiService usersRecevedForProjectNotificationName];
    [nc postNotificationName:notificationName object:self userInfo:userInfo];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchAllUsersForProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:projectKey, errors, nil];
}

@end
