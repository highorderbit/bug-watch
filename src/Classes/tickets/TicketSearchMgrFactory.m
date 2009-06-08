//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketSearchMgrFactory.h"
#import "AccountLevelTicketBinDataSource.h"

@implementation TicketSearchMgrFactory

- (TicketSearchMgr *)
    createTicketSearchMgrWithButton:(UIBarButtonItem *)addButton
    searchText:(NSString *)searchText searchField:(UITextField *)searchField
    wrapperController:(NetworkAwareViewController *)wrapperController
    parentView:(UIView *)parentView ticketBinDataSource:(id)ticketBinDataSource
{
    searchField.text = searchText;

    TicketBinViewController * binViewController =
        [[[TicketBinViewController alloc]
        initWithNibName:@"TicketBinView" bundle:nil] autorelease];

    TicketSearchMgr * ticketSearchMgr =
        [[TicketSearchMgr alloc]
        initWithSearchField:searchField addButton:addButton
        navigationItem:wrapperController.navigationItem
        ticketBinViewController:binViewController
        parentView:parentView dataSourceTarget:ticketBinDataSource
        dataSourceAction:@selector(fetchAllTicketBins)];
    binViewController.delegate = ticketSearchMgr;
    // this won't get dealloced, but fine since it exists for the runtime
    // lifetime

    return ticketSearchMgr;
}

@end
