//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsViewController : UITableViewController <UITextFieldDelegate>
{
    IBOutlet UITextField * searchTextField;
    IBOutlet UIBarButtonItem * cancelButton;
    IBOutlet UIBarButtonItem * addButton;
    
    NSArray * tickets;
}

@property (nonatomic, copy) NSArray * tickets;

- (IBAction)cancelSelected:(id)sender;
- (IBAction)addSelected:(id)sender;

@end
