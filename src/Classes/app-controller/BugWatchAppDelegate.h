//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BugWatchAppController.h"
#import "LighthouseApiServiceDelegate.h"

@interface BugWatchAppDelegate :
    NSObject
    <UIApplicationDelegate, UITabBarControllerDelegate,
    LighthouseApiServiceDelegate>
{
    UIWindow * window;
    UITabBarController * tabBarController;

    IBOutlet BugWatchAppController * appController;
}

@property (nonatomic, retain) IBOutlet UIWindow * window;
@property (nonatomic, retain) IBOutlet UITabBarController * tabBarController;

@end
