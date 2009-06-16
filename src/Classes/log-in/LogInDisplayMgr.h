//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInState.h"
#import "LogInViewControllerDelegate.h"
#import "LighthouseAccountAuthenticatorDelegate.h"

@class LogInViewController;

@interface LogInDisplayMgr :
    NSObject
    <LogInViewControllerDelegate, LighthouseAccountAuthenticatorDelegate>
{
    LogInState * logInState;

    LogInViewController * logInViewController;
    UIViewController * rootViewController;

    NSString * lighthouseDomain;
    NSString * lighthouseScheme;
}

- (id)initWithLogInState:(LogInState *)aLogInState
      rootViewController:(UIViewController *)aRootViewController
        lighthouseDomain:(NSString *)aLighthouseDomain
        lighthouseScheme:(NSString *)aLighthouseScheme;

- (void)logIn;

@end
