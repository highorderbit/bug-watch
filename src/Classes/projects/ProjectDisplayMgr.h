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
#import "MessageDisplayMgr.h"

static const NSInteger PROJECT_TAB_UNSELECTED = -1;

@interface ProjectDisplayMgr :
    NSObject <ProjectsViewControllerDelegate, ProjectHomeViewControllerDelegate>
{
    ProjectsViewController * projectsViewController;
    ProjectHomeViewController * projectHomeViewController;
    NetworkAwareViewController * wrapperController;

    TicketDisplayMgr * ticketDisplayMgr;
    MessageDisplayMgr * messageDisplayMgr;

    ProjectCache * projectCache;    
    id selectedProjectKey;
    NSInteger selectedTab;
}

@property (readonly) ProjectHomeViewController * projectHomeViewController;
@property (readonly) UINavigationController * navController;

@property (readonly) NetworkAwareViewController * ticketsNetAwareViewController;
@property (readonly)
    NetworkAwareViewController * messagesNetAwareViewController;
    
@property (nonatomic, retain) ProjectCache * projectCache;
@property (nonatomic, copy) id selectedProjectKey;
@property (nonatomic, assign) NSInteger selectedTab;

- (id)initWithProjectsViewController:(ProjectsViewController *)aViewController
    networkAwareViewController:(NetworkAwareViewController *)wrapperController
    ticketDisplayMgr:(TicketDisplayMgr *)ticketDisplayMgr
    messageDisplayMgr:(MessageDisplayMgr *)messageDisplayMgr;
    
- (void)presentSelectedTab:(NSUInteger)tabIndex animated:(BOOL)animated;
- (void)presentSelectedProjectKey:(id)key animated:(BOOL)animated;

@end
