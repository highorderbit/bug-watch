//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "AddMessageCommentResponseProcessor.h"

@interface AddMessageCommentResponseProcessor ()

@property (nonatomic, copy) id messageKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) NewMessageCommentDescription * description;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSArray * commentKeys;
@property (nonatomic, retain) NSArray * comments;
@property (nonatomic, retain) NSArray * authors;

@end

@implementation AddMessageCommentResponseProcessor

@synthesize messageKey, projectKey, description, delegate;
@synthesize commentKeys, comments, authors;

+ (id)processorWithMessageKey:(id)aMessageKey
                   projectKey:(id)aProjectKey
                  description:(NewMessageCommentDescription *)aDescription
                     delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithMessageKey:aMessageKey
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
    self.commentKeys = nil;
    self.comments = nil;
    self.authors = nil;
    [super dealloc];
}

- (id)initWithMessageKey:(id)aMessageKey
              projectKey:(id)aProjectKey
             description:(NewMessageCommentDescription *)aDescription
                delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.messageKey = aMessageKey;
        self.projectKey = aProjectKey;
        self.description = aDescription;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponseAsynchronously:(NSData *)xml
{
    self.commentKeys = [self.objectBuilder parseMessageCommentKeys:xml];
    self.comments = [self.objectBuilder parseMessageComments:xml];
    self.authors = [self.objectBuilder parseMessageCommentAuthorIds:xml];
}

- (void)asynchronousProcessorFinished
{
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
