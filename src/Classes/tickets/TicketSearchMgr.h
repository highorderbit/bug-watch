//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketSearchMgrDelegate.h"
#import "TicketBinViewController.h"
#import "TicketBinDataSourceDelegate.h"
#import "TicketBinDataSource.h"

@interface TicketSearchMgr :
    NSObject
    <UITextFieldDelegate, TicketBinDataSourceDelegate,
    TicketBinViewControllerDelegate>
{
    NSObject<TicketSearchMgrDelegate> * delegate;

    UITextField * searchField;
    UIBarButtonItem * addButton;
    UIBarButtonItem * cancelButton;
    UINavigationItem * navigationItem;
    TicketBinViewController * binViewController;
    UIView * parentView;
    id dataSourceTarget;
    SEL dataSourceAction;

    UIView * darkTransparentView;
}

@property (nonatomic, retain) NSObject<TicketSearchMgrDelegate> * delegate;

- (id)initWithSearchField:(UITextField *)aSearchField
    addButton:(UIBarButtonItem *)anAddButton
    navigationItem:(UINavigationItem *)aNavigationItem
    ticketBinViewController:(TicketBinViewController *)aBinViewController
    parentView:(UIView *)parentView dataSourceTarget:(id)aDataSourceTarget
    dataSourceAction:(SEL)aDataSourceAction;

@end
