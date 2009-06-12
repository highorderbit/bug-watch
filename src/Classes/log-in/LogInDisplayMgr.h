//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInState.h"
#import "LogInViewControllerDelegate.h"

@class LogInViewController;

@interface LogInDisplayMgr : NSObject <LogInViewControllerDelegate>
{
    LogInState * logInState;

    LogInViewController * logInViewController;
    UIViewController * rootViewController;
}

- (id)initWithLogInState:(LogInState *)aLogInState
      rootViewController:(UIViewController *)aRootViewController;

- (void)logIn;

@end
