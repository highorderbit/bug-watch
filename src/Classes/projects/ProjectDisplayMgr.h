//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectsViewController.h"
#import "ProjectsViewControllerDelegate.h"
#import "ProjectHomeTableViewCell.h"
#import "ProjectHomeViewController.h"
#import "ProjectCache.h"
#import "NetworkAwareViewController.h"

@interface ProjectDisplayMgr :
    NSObject <ProjectsViewControllerDelegate, ProjectHomeViewControllerDelegate>
{
    ProjectsViewController * projectsViewController;
    ProjectHomeViewController * projectHomeViewController;
    NetworkAwareViewController * wrapperController;

    ProjectCache * projectCache;    
    id selectedProjectKey;
}

- (id)initWithProjectsViewController:(ProjectsViewController *)aViewController
    networkAwareViewController:(NetworkAwareViewController *)wrapperController;

@property (readonly) ProjectHomeViewController * projectHomeViewController;
@property (readonly) UINavigationController * navController;

@property (nonatomic, retain) ProjectCache * projectCache;
@property (nonatomic, copy) id selectedProjectKey;

@end
