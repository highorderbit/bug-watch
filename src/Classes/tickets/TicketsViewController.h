//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketsViewControllerDelegate.h"

@interface TicketsViewController : UITableViewController <UITextFieldDelegate>
{
    NSObject<TicketsViewControllerDelegate> * delegate;
    
    IBOutlet UITextField * searchTextField;
    IBOutlet UIBarButtonItem * cancelButton;
    IBOutlet UIBarButtonItem * addButton;

    NSDictionary * tickets;
}

@property (nonatomic, retain)
    NSObject<TicketsViewControllerDelegate> * delegate;

- (IBAction)cancelSelected:(id)sender;
- (IBAction)addSelected:(id)sender;

- (void)setTickets:(NSDictionary *)someTickets;

@end
