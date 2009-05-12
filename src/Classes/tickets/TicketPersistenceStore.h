//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistenceStore.h"
#import "TicketCache.h"

@interface TicketPersistenceStore : NSObject <PersistenceStore>
{
    TicketCache * ticketCache;
    NSString * plistName;
}

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    plistName:(NSString *)plistName;

@end
