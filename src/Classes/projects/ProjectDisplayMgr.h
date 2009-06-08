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
#import "TicketDisplayMgr.h"

@interface ProjectDisplayMgr :
    NSObject <ProjectsViewControllerDelegate, ProjectHomeViewControllerDelegate>
{
    ProjectsViewController * projectsViewController;
    ProjectHomeViewController * projectHomeViewController;
    NetworkAwareViewController * wrapperController;

    TicketDisplayMgr * ticketDisplayMgr;

    ProjectCache * projectCache;    
    id selectedProjectKey;
}

- (id)initWithProjectsViewController:(ProjectsViewController *)aViewController
    networkAwareViewController:(NetworkAwareViewController *)wrapperController
    ticketDisplayMgr:(TicketDisplayMgr *)ticketDisplayMgr;

@property (readonly) ProjectHomeViewController * projectHomeViewController;
@property (readonly) UINavigationController * navController;

@property (readonly) NetworkAwareViewController * ticketsNetAwareViewController;
    
@property (nonatomic, retain) ProjectCache * projectCache;
@property (nonatomic, copy) id selectedProjectKey;

@end
