//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketCache.h"
#import "TicketCommentCache.h"

@protocol TicketDataSourceDelegate

- (void)receivedTicketsFromDataSource:(TicketCache *)aTicketCache;
- (void)failedToFetchTickets:(NSArray *)errors;
- (void)receivedTicketDetailsFromDataSource:(TicketCommentCache *)commentCache;
- (void)failedToFetchTicketDetails:(NSArray *)errors;
- (void)createdTicketWithKey:(id)ticketKey;
- (void)failedToCreateTicket:(NSArray *)errors;
- (void)deletedTicketWithKey:(id)ticketKey;
- (void)failedToDeleteTicket:(id)ticketKey errors:(NSArray *)errors;
- (void)editedTicketWithKey:(id)ticketKey;
- (void)failedToEditTicket:(id)ticketKey errors:(NSArray *)errors;

@end
