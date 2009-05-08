//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectsViewControllerDelegate.h"

@interface ProjectsViewController : UITableViewController
{
    NSObject<ProjectsViewControllerDelegate> * delegate;
}

@property (nonatomic, retain)
    NSObject<ProjectsViewControllerDelegate> * delegate;
    
@end
