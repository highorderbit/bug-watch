//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketSearchMgrDelegate.h"

@interface TicketSearchMgr : NSObject <UITextFieldDelegate>
{
    NSObject<TicketSearchMgrDelegate> * delegate;

    UITextField * searchField;
    UIBarButtonItem * addButton;
    UIBarButtonItem * cancelButton;
    UINavigationItem * navigationItem;
}

@property (nonatomic, retain) NSObject<TicketSearchMgrDelegate> * delegate;

- (id)initWithSearchField:(UITextField *)aSearchField
    addButton:(UIBarButtonItem *)anAddButton
    cancelButton:(UIBarButtonItem *)aCancelButton
    navigationItem:(UINavigationItem *)aNavigationItem;

@end
