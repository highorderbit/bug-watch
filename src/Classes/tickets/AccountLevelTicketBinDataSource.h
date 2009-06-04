//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketBinDataSourceDelegate.h"
#import "TicketBinDataSourceProtocol.h"

@interface AccountLevelTicketBinDataSource :
    NSObject <TicketBinDataSourceProtocol>
{
    NSObject<TicketBinDataSourceDelegate> * delegate;
    NSArray * ticketBins;
}

- (void)fetchAllTicketBins;

@end
