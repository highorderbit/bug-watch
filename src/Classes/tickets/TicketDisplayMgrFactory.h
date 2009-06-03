//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDisplayMgr.h"
#import "LighthouseApiServiceFactory.h"
#import "TicketSearchMgr.h"

@interface TicketDisplayMgrFactory : NSObject
{
    NSString * apiToken;
    LighthouseApiServiceFactory * lighthouseApiFactory;
}

- (id)initWithApiToken:(NSString *)apiToken
    lighthouseApiFactory:(LighthouseApiServiceFactory *)lighthouseApiFactory;

- (TicketDisplayMgr *)createTicketDisplayMgrWithCache:(TicketCache *)ticketCache
    wrapperController:(NetworkAwareViewController *)wrapperController
    ticketSearchMgr:(TicketSearchMgr *)ticketSearchMgr;

@end
