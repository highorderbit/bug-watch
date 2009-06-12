//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInViewControllerDelegate.h"

@interface LogInViewController : UIViewController
{
    id<LogInViewControllerDelegate> delegate;

    IBOutlet UIBarButtonItem * logInButton;
    IBOutlet UIBarButtonItem * cancelButton;
}

@property (nonatomic, assign) id<LogInViewControllerDelegate> delegate;

@end
