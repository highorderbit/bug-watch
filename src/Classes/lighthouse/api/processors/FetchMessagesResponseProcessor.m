//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchMessagesResponseProcessor.h"
#import "LighthouseApiService.h"  // for the notification name

@interface FetchMessagesResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSArray * messages;
@property (nonatomic, retain) NSArray * messageKeys;
@property (nonatomic, retain) NSArray * authorKeys;

@end

@implementation FetchMessagesResponseProcessor

@synthesize projectKey, delegate;
@synthesize messages, messageKeys, authorKeys;

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

    self.messages = nil;
    self.messageKeys = nil;
    self.authorKeys = nil;

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
    self.messages = [self.objectBuilder parseMessages:xml];
    self.messageKeys = [self.objectBuilder parseMessageKeys:xml];
    self.authorKeys = [self.objectBuilder parseMessageAuthorKeys:xml];
}

- (void)asynchronousProcessorFinished
{
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
