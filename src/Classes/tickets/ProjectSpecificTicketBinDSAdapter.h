//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDisplayMgr.h"
#import "TicketBinDataSource.h"
#import "TicketBinDataSourceProtocol.h"
#import "TicketBinDataSourceDelegate.h"

@interface ProjectSpecificTicketBinDSAdapter :
    NSObject <TicketBinDataSourceDelegate, TicketBinDataSourceProtocol>
{
    NSObject<TicketBinDataSourceDelegate> * delegate;

    TicketDisplayMgr * ticketDisplayMgr;
    TicketBinDataSource * ticketBinDataSource;
}

@property (nonatomic, assign) NSObject<TicketBinDataSourceDelegate> * delegate;
@property (nonatomic, retain) TicketDisplayMgr * ticketDisplayMgr;

- (id)initWithTicketBinDataSource:(TicketBinDataSource *)ticketBinDataSource;
- (void)fetchAllTicketBins;

@end
