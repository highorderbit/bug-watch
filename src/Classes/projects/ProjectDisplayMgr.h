//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectsViewController.h"
#import "ProjectsViewControllerDelegate.h"
#import "ProjectHomeTableViewCell.h"
#import "ProjectHomeViewController.h"

@interface ProjectDisplayMgr : NSObject <ProjectsViewControllerDelegate>
{
    id projectCache;
    ProjectsViewController * projectsViewController;
    ProjectHomeViewController * projectHomeViewController;
}

- (id)initWithProjectCache:(id)aProjectCache
    projectsViewController:(ProjectsViewController *)aProjectsViewController;

@property (readonly) ProjectHomeViewController * projectHomeViewController;
@property (readonly) UINavigationController * navController;

@end
