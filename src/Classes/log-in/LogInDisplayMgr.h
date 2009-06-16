//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogInViewControllerDelegate.h"
#import "LighthouseAccountAuthenticatorDelegate.h"

@class LighthouseCredentials, LogInViewController;

@interface LogInDisplayMgr :
    NSObject
    <LogInViewControllerDelegate, LighthouseAccountAuthenticatorDelegate>
{
    LighthouseCredentials * credentials;

    LogInViewController * logInViewController;
    UIViewController * rootViewController;

    NSString * lighthouseDomain;
    NSString * lighthouseScheme;
}

- (id)initWithCredentials:(LighthouseCredentials *)someCredentials
       rootViewController:(UIViewController *)aRootViewController
         lighthouseDomain:(NSString *)aLighthouseDomain
         lighthouseScheme:(NSString *)aLighthouseScheme;

- (void)logIn;

@end
