//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDataSource.h"

@implementation MessageDataSource

@synthesize delegate, token;

- (void)dealloc
{
    [service release];
    [token release];
    [super dealloc];
}

- (id)initWithService:(LighthouseApiService *)aService
{
    if (self = [super init])
        service = [aService retain];

    return self;
}

- (void)fetchMessagesForProject:(id)projectKey
{
    [service fetchMessagesForProject:projectKey token:self.token];
}

- (void)messages:(NSArray *)messages messageKeys:(NSArray *)messageKeys
    authorKeys:(NSArray *)authorKeys fetchedForProject:(id)projectKey
{
    MessageCache * messageCache = [[[MessageCache alloc] init] autorelease];
    for (int i = 0; i < [messages count]; i++) {
        id messageKey = [messageKeys objectAtIndex:i];
        Message * message = [messages objectAtIndex:i];
        id authorKey = [authorKeys objectAtIndex:i];
        [messageCache setMessage:message forKey:messageKey];
        [messageCache setProjectKey:projectKey forKey:messageKey];
        [messageCache setPostedByKey:authorKey forKey:messageKey];
    }

    [delegate receivedMessagesFromDataSource:messageCache];
}

- (void)failedToFetchMessagesForProject:(id)projectKey error:(NSError *)error
{}

@end
