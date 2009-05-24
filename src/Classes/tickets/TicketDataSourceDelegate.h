//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketCache.h"
#import "TicketCommentCache.h"

@protocol TicketDataSourceDelegate

- (void)receivedTicketsFromDataSource:(TicketCache *)aTicketCache;
- (void)receivedTicketDetailsFromDataSource:(TicketCommentCache *)commentCache;
- (void)createdTicketWithKey:(id)ticketKey;

@end
