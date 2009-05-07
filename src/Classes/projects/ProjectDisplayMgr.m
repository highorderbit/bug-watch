//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectDisplayMgr.h"

@implementation ProjectDisplayMgr

- (void)dealloc
{
    [projectCache release];
    [navController release];
    [projectsViewController release];
    [projectHomeViewController release];
    [super dealloc];
}

- (id)initWithProjectCache:(id)aProjectCache
    navigationController:(UINavigationController *)aNavController
    projectsViewController:(ProjectsViewController *)aProjectsViewController
{
    if (self = [super init]) {
        projectCache = [aProjectCache retain];
        navController = [aNavController retain];
        projectsViewController = [aProjectsViewController retain];
    }

    return self;
}

#pragma mark ProjectsViewControllerDelegate implementation

- (void)selectedProjectKey:(id)key
{
    NSLog(@"Project %@ selected", key);
    [navController pushViewController:self.projectHomeViewController
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

@end
