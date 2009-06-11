//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AddMessageCommentResponseProcessor.h"

@interface AddMessageCommentResponseProcessor ()

@property (nonatomic, copy) id messageKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) NewMessageCommentDescription * description;
@property (nonatomic, assign) id delegate;

@end

@implementation AddMessageCommentResponseProcessor

@synthesize messageKey, projectKey, description, delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                messageKey:(id)aMessageKey
                projectKey:(id)aProjectKey
               description:(NewMessageCommentDescription *)aDescription
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
          description:(NewMessageCommentDescription *)aDescription
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
    NSArray * commentKeys = [self.objectBuilder parseMessageCommentKeys:xml];
    NSArray * comments = [self.objectBuilder parseMessageComments:xml];
    NSArray * authors = [self.objectBuilder parseMessageCommentAuthorIds:xml];

    NSAssert3(commentKeys.count == 1 && comments.count == 1 &&
        authors.count == 1, @"Expected 1 new message comment, but got: %@, %@, "
        "%@.", commentKeys, comments, authors);

    SEL sel = @selector(comment:withKey:authorKey:addedToMessage:forProject:\
        describedBy:);
    [self invokeSelector:sel withTarget:delegate args:[comments lastObject],
        [commentKeys lastObject], [authors lastObject], messageKey, projectKey,
        description, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel =
        @selector(failedToAddCommentToMessage:forProject:describedBy:errors:);
    [self invokeSelector:sel withTarget:delegate args:messageKey, projectKey,
        description, errors, nil];
}

@end
