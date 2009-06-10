//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "EditMessageResponseProcessor.h"
#import "UpdateMessageDescription.h"

@interface EditMessageResponseProcessor ()

@property (nonatomic, copy) id messageKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) UpdateMessageDescription * description;
@property (nonatomic, assign) id delegate;

@end

@implementation EditMessageResponseProcessor

@synthesize messageKey, projectKey, description, delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                messageKey:(id)aMessageKey
                projectKey:(id)aProjectKey
               description:(UpdateMessageDescription *)aDescription
                  delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                        messageKey:aMessageKey
                                        projectKey:aProjectKey
                                       description:aDescription
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.messageKey = nil;
    self.projectKey = nil;
    self.description = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           messageKey:(id)aMessageKey
           projectKey:(id)aProjectKey
          description:(UpdateMessageDescription *)aDescription
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.messageKey = aMessageKey;
        self.projectKey = aProjectKey;
        self.description = aDescription;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponse:(NSData *)xml
{
    SEL sel = @selector(editedMessage:forProject:describedBy:);
    [self invokeSelector:sel withTarget:delegate args:messageKey,
        projectKey, description, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToEditMessage:forProject:describedBy:errors:);
    [self invokeSelector:sel withTarget:delegate args:messageKey,
        projectKey, description, errors, nil];
}

@end
