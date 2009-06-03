//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectDisplayMgr.h"

@implementation ProjectDisplayMgr

@synthesize projectCache, selectedProjectKey;

- (void)dealloc
{
    [projectsViewController release];
    [projectHomeViewController release];

    [projectCache release];
    [selectedProjectKey release];

    [super dealloc];
}

- (id)initWithProjectsViewController:(ProjectsViewController *)aViewController
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
{
    if (self = [super init]) {
        projectsViewController = [aViewController retain];
        wrapperController = [aWrapperController retain];
    }

    return self;
}

#pragma mark ProjectsViewControllerDelegate implementation

- (void)selectedProjectKey:(id)key
{
    NSLog(@"Project %@ selected", key);

    self.selectedProjectKey = key;

    Project * project = [projectCache projectForKey:key];
    // setting this twice -- once before and once after pushing the nav
    // controller -- seems to fix some UI glitches
    self.projectHomeViewController.navigationItem.title = project.name;

    [self.navController pushViewController:self.projectHomeViewController
        animated:YES];

    self.projectHomeViewController.navigationItem.title = project.name;
}

#pragma mark ProjectHomeViewControllerDelegate implementation

- (void)selectedTab:(NSUInteger)tab
{
    // init tickets tab from factory
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
    return wrapperController.navigationController;
}

- (void)setProjectCache:(ProjectCache *)aProjectCache
{
    [aProjectCache retain];
    [projectCache release];
    projectCache = aProjectCache;

    NSDictionary * allProjects = [aProjectCache allProjects];
    NSMutableDictionary * names = [NSMutableDictionary dictionary];
    for (id key in [allProjects allKeys]) {
        Project * project = [allProjects objectForKey:key];
        [names setObject:project.name forKey:key];
    }

    NSDictionary * allProjectMetadata = [aProjectCache allProjectMetadata];
    NSMutableDictionary * openTicketCounts = [NSMutableDictionary dictionary];
    for (id key in [allProjectMetadata allKeys]) {
        ProjectMetadata * metadata = [allProjectMetadata objectForKey:key];
        [openTicketCounts
            setObject:[NSNumber numberWithInt:metadata.openTicketsCount]
            forKey:key];
    }

    [projectsViewController setNames:names openTicketCounts:openTicketCounts];

    [wrapperController setCachedDataAvailable:YES];
    [wrapperController setUpdatingState:kConnectedAndNotUpdating];
}

@end
