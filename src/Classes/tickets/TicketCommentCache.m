//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketCommentCache.h"

@implementation TicketCommentCache

- (void)dealloc
{
    [comments release];
    [commentAuthors release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        comments = [[NSMutableDictionary dictionary] retain];
        commentAuthors = [[NSMutableDictionary dictionary] retain];
    }

    return self;
}

- (void)setComment:(TicketComment *)comment forKey:(id)key
{
    [comments setObject:comment forKey:key];
}

- (TicketComment *)commentForKey:(id)key
{
    return [comments objectForKey:key];
}

- (void)setAuthorKey:(id)authorKey forCommentKey:(id)commentKey
{
    [commentAuthors setObject:authorKey forKey:commentKey];
}

- (id)authorKeyForCommentKey:(id)commentKey
{
    return [commentAuthors objectForKey:commentKey];
}

@end
