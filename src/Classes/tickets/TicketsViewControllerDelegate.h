//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketKey.h"

@protocol TicketsViewControllerDelegate

- (void)selectedTicketKey:(TicketKey *)key;

@end
