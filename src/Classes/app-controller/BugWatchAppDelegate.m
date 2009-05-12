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

    // temporary
    LighthouseApiService * lighthouse =
        [[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"];
    lighthouse.delegate = self;

    NSString * token = @"6998f7ed27ced7a323b256d83bd7fec98167b1b3";
    [lighthouse searchTicketsForAllProjects:@"user view" token:token];
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

#pragma mark LighthouseApiServiceDelegate implementation

- (void)tickets:(NSArray *)tickets
    fetchedForSearchString:(NSString *)searchString
    metadata:(NSArray *)metadata ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds userIds:(NSArray *)userIds
    creatorIds:(NSArray *)creatorIds;
{
    NSLog(@"Search string: '%@' yielded search results: %@.", searchString,
        tickets);
}

- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    error:(NSError *)error
{
    NSLog(@"Failed to search for: '%@', error: %@.", searchString, error);
}

@end
