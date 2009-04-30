//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TicketsViewControllerDelegate

- (void)selectedTicketNumber:(NSUInteger)number;
- (void)ticketsFilteredByFilterKey:(NSString *)filterKey;

@end
