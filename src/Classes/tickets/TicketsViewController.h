//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UITableViewController <UITextFieldDelegate>
{
    IBOutlet UITextField * searchTextField;
    IBOutlet UIBarButtonItem * cancelButton;
    IBOutlet UIBarButtonItem * addButton;
}

- (IBAction)cancelSelected:(id)sender;
- (IBAction)addSelected:(id)sender;

@end
