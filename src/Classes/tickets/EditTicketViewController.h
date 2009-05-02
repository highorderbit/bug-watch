//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTicketViewController : UIViewController
{
    IBOutlet UITableView * tableView;
    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
}

- (IBAction)cancel:(id)sender;

@end
