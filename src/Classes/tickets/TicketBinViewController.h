//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TicketBinViewControllerDelegate.h"

@interface TicketBinViewController : UITableViewController
{
    NSObject<TicketBinViewControllerDelegate> * delegate;
    NSDictionary * ticketBins;
}

@property (nonatomic, assign)
    NSObject<TicketBinViewControllerDelegate> * delegate;

- (void)setTicketBins:(NSDictionary *)ticketBins;

@end
