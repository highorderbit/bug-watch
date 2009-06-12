//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInDisplayMgr.h"
#import "LogInViewController.h"

@interface LogInDisplayMgr ()

- (void)beginLogIn;
- (void)beginLogOut;

- (void)promptForLogOutConfirmation;

@property (nonatomic, copy) LogInState * logInState;
@property (nonatomic, retain) LogInViewController * logInViewController;
@property (nonatomic, retain) UIViewController * rootViewController;

@end

@implementation LogInDisplayMgr

@synthesize logInState, logInViewController, rootViewController;

- (void)dealloc
{
    self.logInState = nil;
    self.logInViewController = nil;
    self.rootViewController = nil;
    [super dealloc];
}

- (id)initWithLogInState:(LogInState *)aLogInState
      rootViewController:(UIViewController *)aRootViewController
{
    if (self = [super init]) {
        self.logInState = aLogInState;
        self.rootViewController = aRootViewController;
    }

    return self;
}

- (void)logIn
{
    NSLog(@"User tapped log in button.");

    if (logInState)
        [self beginLogOut];
    else
        [self beginLogIn];
}

- (void)beginLogIn
{
    [rootViewController presentModalViewController:self.logInViewController
                                          animated:YES];
}

- (void)beginLogOut
{
    [self promptForLogOutConfirmation];
}

#pragma mark LogInViewController delegate implementation

- (void)userDidProvideAccount:(NSString *)account
                     username:(NSString *)username
                     password:(NSString *)password
{
    NSLog(@"User provided account: '%@', username: '%@', password: '********'.",
        account, username);
}

- (void)userDidCancel
{
    [rootViewController dismissModalViewControllerAnimated:YES];

    // notify delegate that log in was cancelled.
}

- (void)promptForLogOutConfirmation
{
}

#pragma mark Accessors

- (LogInViewController *)logInViewController
{
    if (!logInViewController) {
        logInViewController =
            [[LogInViewController alloc] initWithNibName:@"LogInView"
                                                  bundle:nil];
        logInViewController.delegate = self;
    }

    return logInViewController;
}

@end
