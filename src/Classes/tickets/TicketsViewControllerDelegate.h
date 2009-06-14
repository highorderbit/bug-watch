//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseKey.h"

@protocol TicketsViewControllerDelegate

- (void)selectedTicketKey:(LighthouseKey *)key;
- (void)loadMoreTickets;
- (void)resolveTicketWithKey:(LighthouseKey *)key;

@end
