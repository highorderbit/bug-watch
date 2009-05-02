//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticket.h"
#import "EditTicketViewController.h"

@interface TicketDetailsViewController : UITableViewController
{
    IBOutlet UIView * headerView;
    EditTicketViewController * editTicketViewController;
}

@property (nonatomic, readonly)
    EditTicketViewController * editTicketViewController;

- (void)setTicketNumber:(NSUInteger)aNumber ticket:(Ticket *)aTicket;

@end
