//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchUsersResponseProcessor.h"
#import "LighthouseApiService.h"  // for the notification name

@interface FetchUsersResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@property (nonatomic, copy) NSArray * users;
@property (nonatomic, copy) NSArray * userKeys;

@end

@implementation FetchUsersResponseProcessor

@synthesize projectKey, delegate;
@synthesize users, userKeys;

+ (id)processorWithProjectKey:(id)aProjectKey
                     delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithProjectKey:aProjectKey
                                             delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.projectKey = nil;
    self.delegate = nil;
    self.users = nil;
    self.userKeys = nil;
    [super dealloc];
}

- (id)initWithProjectKey:(id)aProjectKey
                delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponseAsynchronously:(NSData *)xml
{
    self.users = [self.objectBuilder parseUsers:xml];
    self.userKeys = [self.objectBuilder parseUserKeys:xml];
    NSLog(@"%d: Will build a dict with %d keys and %d objects.",
        self, userKeys.count, users.count);
}

- (void)asynchronousProcessorFinished
{
    NSLog(@"%d: Building a dict with %d keys and %d objects.",
        self, userKeys.count, users.count);
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
