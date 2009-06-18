//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CreateMessageResponseProcessor.h"
#import "NewMessageDescription.h"

@interface CreateMessageResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) NewMessageDescription * description;
@property (nonatomic, assign) id delegate;

@end

@implementation CreateMessageResponseProcessor

@synthesize projectKey, description, delegate;

+ (id)processorWithProjectKey:(id)aProjectKey
                  description:(NewMessageDescription *)aDescription
                     delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithProjectKey:aProjectKey
                                          description:aDescription
                                             delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.projectKey = nil;
    self.description = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithProjectKey:(id)aProjectKey
             description:(NewMessageDescription *)aDescription
                delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.projectKey = aProjectKey;
        self.description = aDescription;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponse:(NSData *)xml
{
    NSArray * keys = [self.objectBuilder parseMessageKeys:xml];
    NSAssert2(keys.count == 1, @"Expected 1 message ID, but received %d: %@.",
        keys.count, keys);
    id messageKey = [keys lastObject];

    SEL sel = @selector(message:describedBy:createdForProject:);
    [self invokeSelector:sel withTarget:delegate args:messageKey, description,
        projectKey, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToCreateMessageDescribedBy:forProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:description, projectKey,
        errors, nil];
}

@end