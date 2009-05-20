//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketComment.h"

@interface TicketCommentCache : NSObject
{
    NSMutableDictionary * comments;
    NSMutableDictionary * commentAuthors;
}

- (void)setComment:(TicketComment *)comment forKey:(id)key;
- (TicketComment *)commentForKey:(id)key;
- (NSDictionary *)allComments;

- (void)setAuthorKey:(id)authorKey forCommentKey:(id)commentKey;
- (id)authorKeyForCommentKey:(id)commentKey;

@end
