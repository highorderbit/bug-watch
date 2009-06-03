//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectHomeViewControllerDelegate.h"

enum ProjectTab
{
    kProjectHome,
    kProjectTickets,
    kProjectMilestones,
    kProjectMessages
};

@interface ProjectHomeViewController : UITableViewController
{
    NSObject<ProjectHomeViewControllerDelegate> * delegate;
}

@property (nonatomic, assign)
    NSObject<ProjectHomeViewControllerDelegate> * delegate;

@end
