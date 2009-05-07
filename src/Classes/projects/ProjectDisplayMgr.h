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
    UINavigationController * navController;
    ProjectsViewController * projectsViewController;
    
    ProjectHomeViewController * projectHomeViewController;
}

- (id)initWithProjectCache:(id)aProjectCache
    navigationController:(UINavigationController *)aNavController
    projectsViewController:(ProjectsViewController *)aProjectsViewController;

@property (nonatomic, readonly)
    ProjectHomeViewController * projectHomeViewController;

@end
