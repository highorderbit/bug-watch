//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectsViewControllerDelegate.h"

@interface ProjectsViewController : UITableViewController
{
    NSObject<ProjectsViewControllerDelegate> * delegate;

    NSDictionary * names;
    NSDictionary * openTicketCounts;
}

@property (nonatomic, assign)
    NSObject<ProjectsViewControllerDelegate> * delegate;

- (void)setNames:(NSDictionary *)names
    openTicketCounts:(NSDictionary *)openTicketCounts;

@end
