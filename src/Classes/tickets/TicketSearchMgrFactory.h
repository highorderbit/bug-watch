//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketSearchMgr.h"
#import "NetworkAwareViewController.h"

@interface TicketSearchMgrFactory : NSObject

- (TicketSearchMgr *)
    createTicketSearchMgrWithButton:(UIBarButtonItem *)addButton
    searchText:(NSString *)searchText searchField:(UITextField *)searchField
    wrapperController:(NetworkAwareViewController *)wrapperController;

@end
