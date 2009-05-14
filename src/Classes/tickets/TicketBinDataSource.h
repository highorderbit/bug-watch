//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"
#import "LighthouseApiDelegate.h"
#import "TicketBinDataSourceDelegate.h"

@interface TicketBinDataSource : NSObject <LighthouseApiServiceDelegate>
{
    NSObject<TicketBinDataSourceDelegate> * delegate;
    LighthouseApiService * service;
}

@property (nonatomic, assign) NSObject<TicketBinDataSourceDelegate> * delegate;

-(id)initWithService:(LighthouseApiService *)service;
- (void)fetchAllTicketBins;

@end
