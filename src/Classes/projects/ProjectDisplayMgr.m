//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectDisplayMgr.h"

@implementation ProjectDisplayMgr

- (void)dealloc
{
    [projectCache release];
    [projectsViewController release];
    [projectHomeViewController release];
    [super dealloc];
}

- (id)initWithProjectCache:(id)aProjectCache
    projectsViewController:(ProjectsViewController *)aProjectsViewController
{
    if (self = [super init]) {
        projectCache = [aProjectCache retain];
        projectsViewController = [aProjectsViewController retain];
    }

    return self;
}

#pragma mark ProjectsViewControllerDelegate implementation

- (void)selectedProjectKey:(id)key
{
    NSLog(@"Project %@ selected", key);
    [self.navController pushViewController:self.projectHomeViewController
        animated:YES];
}

#pragma mark Accessors

- (ProjectHomeViewController *)projectHomeViewController
{
    if (!projectHomeViewController)
        projectHomeViewController =
            [[ProjectHomeViewController alloc]
            initWithNibName:@"ProjectHomeView" bundle:nil];

    return projectHomeViewController;
}

- (UINavigationController *)navController
{
    return projectsViewController.navigationController;
}

@end
