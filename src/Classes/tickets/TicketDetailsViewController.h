//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"

@interface TicketDetailsViewController : UITableViewController
{
    IBOutlet UIView * headerView;
}

- (void)setTicketNumber:(NSUInteger)aNumber ticket:(Ticket *)aTicket;

@end
