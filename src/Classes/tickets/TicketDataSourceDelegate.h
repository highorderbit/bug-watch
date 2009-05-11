//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketCache.h"

@protocol TicketDataSourceDelegate

- (void)receivedTicketsFromDataSource:(TicketCache *)aTicketCache;

@end
