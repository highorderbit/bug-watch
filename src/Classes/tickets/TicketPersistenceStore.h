//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketCache.h"

@interface TicketPersistenceStore : NSObject

- (TicketCache *)loadWithPlist:(NSString *)plist;
- (void)saveTicketCache:(TicketCache *)ticketCache toPlist:(NSString *)plist;

@end
