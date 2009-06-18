//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "FetchMessageCommentsResponseProcessor.h"

@interface FetchMessageCommentsResponseProcessor ()

@property (nonatomic, copy) id messageKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) NSArray * commentKeys;
@property (nonatomic, retain) NSArray * comments;
@property (nonatomic, retain) NSArray * authors;

@end

@implementation FetchMessageCommentsResponseProcessor

@synthesize messageKey, projectKey, delegate;
@synthesize commentKeys, comments, authors;

+ (id)processorWithMessageKey:(id)aMessageKey
                   projectKey:(id)aProjectKey
                     delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithMessageKey:aMessageKey
                                           projectKey:aProjectKey
                                             delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.messageKey = nil;
    self.projectKey = nil;
    self.delegate = nil;

    self.commentKeys = nil;
    self.comments = nil;
    self.authors = nil;

    [super dealloc];
}

- (id)initWithMessageKey:(id)aMessageKey
              projectKey:(id)aProjectKey
                delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.messageKey = aMessageKey;
        self.projectKey = aProjectKey;
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
