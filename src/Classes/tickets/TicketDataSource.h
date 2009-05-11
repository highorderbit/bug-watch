//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDataSourceDelegate.h"
#import "LighthouseApiService.h"
#import "LighthouseApiDelegate.h"

@interface TicketDataSource : NSObject <LighthouseApiServiceDelegate>
{
    NSObject<TicketDataSourceDelegate> * delegate;
    LighthouseApiService * service;
}

@property (nonatomic, retain) NSObject<TicketDataSourceDelegate> * delegate;

-(id)initWithService:(LighthouseApiService *)service;

- (void)fetchTicketsWithQuery:(NSString *)aFilterString;

@end
