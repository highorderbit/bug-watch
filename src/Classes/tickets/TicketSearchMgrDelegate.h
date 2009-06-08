//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TicketSearchMgrDelegate

- (void)ticketsFilteredByFilterString:(NSString *)filterString;
- (void)forceQueryRefresh;

@end
