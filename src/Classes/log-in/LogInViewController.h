//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInViewControllerDelegate.h"

@interface LogInViewController : UIViewController
{
    id<LogInViewControllerDelegate> delegate;

    IBOutlet UITableView * tableView;

    IBOutlet UIBarButtonItem * logInButton;

    IBOutlet UITableViewCell * accountCell;
    IBOutlet UITableViewCell * usernameCell;
    IBOutlet UITableViewCell * passwordCell;

    IBOutlet UITextField * accountTextField;
    IBOutlet UITextField * usernameTextField;
    IBOutlet UITextField * passwordTextField;

    NSString * lighthouseDomain;
    NSString * lighthouseScheme;
}

@property (nonatomic, assign) id<LogInViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString * lighthouseDomain;
@property (nonatomic, copy) NSString * lighthouseScheme;

- (void)promptForLogIn;

@end
