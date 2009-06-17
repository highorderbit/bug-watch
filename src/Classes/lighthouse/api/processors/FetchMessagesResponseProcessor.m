//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchMessagesResponseProcessor.h"
#import "LighthouseApiService.h"  // for the notification name

@interface FetchMessagesResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@end

@implementation FetchMessagesResponseProcessor

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
    NSArray * messages = [self.objectBuilder parseMessages:xml];
    NSArray * messageKeys = [self.objectBuilder parseMessageKeys:xml];
    NSArray * authorKeys = [self.objectBuilder parseMessageAuthorKeys:xml];

    SEL sel = @selector(messages:messageKeys:authorKeys:fetchedForProject:);
    [self invokeSelector:sel withTarget:delegate args:messages, messageKeys,
        authorKeys, projectKey, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchMessagesForProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:projectKey, errors, nil];
}

@end
