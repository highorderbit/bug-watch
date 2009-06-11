//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchMessageCommentsResponseProcessor.h"

@interface FetchMessageCommentsResponseProcessor ()

@property (nonatomic, copy) id messageKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@end

@implementation FetchMessageCommentsResponseProcessor

@synthesize messageKey, projectKey, delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                messageKey:(id)aMessageKey
                projectKey:(id)aProjectKey
                  delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                        messageKey:aMessageKey
                                        projectKey:aProjectKey
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.messageKey = nil;
    self.projectKey = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           messageKey:(id)aMessageKey
           projectKey:(id)aProjectKey
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.messageKey = aMessageKey;
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponse:(NSData *)xml
{
    NSArray * commentKeys = [self.objectBuilder parseMessageCommentKeys:xml];
    NSArray * comments = [self.objectBuilder parseMessageComments:xml];
    NSArray * authors = [self.objectBuilder parseMessageCommentAuthorIds:xml];

    SEL sel = @selector(comments:commentKeys:authorKeys:fetchedForMessage:\
        inProject:);
    [self invokeSelector:sel withTarget:delegate args:comments, commentKeys,
        authors, messageKey, projectKey, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToFetchCommentsForMessage:inProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:messageKey, projectKey,
        errors, nil];
}

@end
