//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "ProjectDisplayMgr.h"

@implementation ProjectDisplayMgr

@synthesize projectCache, selectedProjectKey, selectedTab;

- (void)dealloc
{
    [projectsViewController release];
    [projectHomeViewController release];

    [ticketDisplayMgr release];
    [messageDisplayMgr release];

    [projectCache release];
    [selectedProjectKey release];

    [super dealloc];
}

- (id)initWithProjectsViewController:(ProjectsViewController *)aViewController
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    ticketDisplayMgr:(TicketDisplayMgr *)aTicketDisplayMgr
    messageDisplayMgr:(MessageDisplayMgr *)aMessageDisplayMgr
{
    if (self = [super init]) {
        projectsViewController = [aViewController retain];
        wrapperController = [aWrapperController retain];
        ticketDisplayMgr = [aTicketDisplayMgr retain];
        messageDisplayMgr = [aMessageDisplayMgr retain];
        self.selectedTab = PROJECT_TAB_UNSELECTED;
        changedProject = NO;
    }

    return self;
}

#pragma mark ProjectsViewControllerDelegate implementation

- (void)selectedProjectKey:(id)key
{
    [self presentSelectedProjectKey:key animated:YES];
}

- (void)deselectedProject
{
    NSLog(@"Deselected project.");

    self.selectedProjectKey = 0;

    // clear data specific to previous project
    ticketDisplayMgr.ticketCache = nil;
    messageDisplayMgr.messageCache = nil;

    changedProject = YES;
}

- (void)presentSelectedProjectKey:(id)key animated:(BOOL)animated
{
    NSLog(@"Project %@ selected", key);

    self.selectedProjectKey = key;

    Project * project = [projectCache projectForKey:key];
    // setting this twice -- once before and once after pushing the nav
    // controller -- seems to fix some UI glitches
    self.projectHomeViewController.navigationItem.title = project.name;

    self.projectHomeViewController.navigationItem.title = project.name;
    ticketDisplayMgr.activeProjectKey = key;
    messageDisplayMgr.activeProjectKey = key;
    if (changedProject) {
        [ticketDisplayMgr ticketsFilteredByFilterString:@""];
        [messageDisplayMgr showAllMessages];
    }

    [self.navController pushViewController:self.projectHomeViewController
        animated:animated];

    changedProject = NO;
}

#pragma mark ProjectHomeViewControllerDelegate implementation

- (void)selectedTab:(NSUInteger)tabIndex
{
    [self presentSelectedTab:tabIndex animated:YES];
}

- (void)deselectedTab
{
    selectedTab = PROJECT_TAB_UNSELECTED;
}

- (void)presentSelectedTab:(NSUInteger)tabIndex animated:(BOOL)animated
{
    NSLog(@"Selected project tab %d", tabIndex);
    selectedTab = tabIndex;

    switch(tabIndex) {
        case kProjectTickets:
            [self.navController
                pushViewController:self.ticketsNetAwareViewController
                animated:animated];
            break;
        case kProjectMessages:
            [self.navController
                pushViewController:self.messagesNetAwareViewController
                animated:animated];
            break;
    }
}

#pragma mark Accessors

- (ProjectHomeViewController *)projectHomeViewController
{
    if (!projectHomeViewController) {
        projectHomeViewController =
            [[ProjectHomeViewController alloc]
            initWithNibName:@"ProjectHomeView" bundle:nil];
        projectHomeViewController.delegate = self;
    }

    return projectHomeViewController;
}

- (UINavigationController *)navController
{
    return wrapperController.navigationController;
}

- (NetworkAwareViewController *)ticketsNetAwareViewController
{
    return ticketDisplayMgr.wrapperController;
}

- (NetworkAwareViewController *)messagesNetAwareViewController
{
    return messageDisplayMgr.wrapperController;
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
