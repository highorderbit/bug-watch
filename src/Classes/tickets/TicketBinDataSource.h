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
    NSString * token;
}

- (id)initWithService:(LighthouseApiService *)service token:(NSString *)aToken;
- (void)fetchAllTicketBinsForProject:(id)projectKey;

@end
