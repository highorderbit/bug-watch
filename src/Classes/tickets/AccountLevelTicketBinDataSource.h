//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketBinDataSourceDelegate.h"

@interface AccountLevelTicketBinDataSource : NSObject
{
    NSObject<TicketBinDataSourceDelegate> * delegate;
    NSArray * ticketBins;
}

@property (nonatomic, assign) NSObject<TicketBinDataSourceDelegate> * delegate;

- (void)fetchAllTicketBins;

@end
