//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"
#import "LighthouseApiDelegate.h"
#import "TicketBinDataSourceDelegate.h"
#import "TicketBinDataSourceProtocol.h"

@interface TicketBinDataSource :
    NSObject <LighthouseApiServiceDelegate, TicketBinDataSourceProtocol>
{
    NSObject<TicketBinDataSourceDelegate> * delegate;
    LighthouseApiService * service;
}

-(id)initWithService:(LighthouseApiService *)service;
- (void)fetchAllTicketBins;

@end
