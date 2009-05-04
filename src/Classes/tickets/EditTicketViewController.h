//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCommentViewController.h"
#import "ItemSelectionTableViewController.h"

@interface EditTicketViewController :
    UITableViewController <UITextFieldDelegate>
{
    IBOutlet UIView * headerView;
    IBOutlet UIBarButtonItem * cancelButton;
    IBOutlet UIBarButtonItem * updateButton;
    IBOutlet UITextField * descriptionTextField;
    IBOutlet UITextField * tagsTextField;
    
    AddCommentViewController * addCommentViewController;
    ItemSelectionTableViewController * itemSelectionTableViewController;
}

@property (nonatomic, readonly)
    AddCommentViewController * addCommentViewController;
@property (nonatomic, readonly)
    ItemSelectionTableViewController * itemSelectionTableViewController;
    
- (IBAction)cancel:(id)sender;
- (IBAction)update:(id)sender;

@end
