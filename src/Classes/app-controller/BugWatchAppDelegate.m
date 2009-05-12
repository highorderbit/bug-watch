//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "BugWatchAppDelegate.h"
#import "LighthouseApiService.h"

@implementation BugWatchAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [appController start];
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

- (void)dealloc
{
    [tabBarController release];
    [window release];
    
    [appController release];
    
    [super dealloc];
}

@end
