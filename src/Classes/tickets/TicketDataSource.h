//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketDataSourceDelegate.h"
#import "LighthouseApiService.h"
#import "LighthouseApiDelegate.h"
#import "TicketKey.h"

@interface TicketDataSource : NSObject <LighthouseApiServiceDelegate>
{
    NSObject<TicketDataSourceDelegate> * delegate;
    LighthouseApiService * service;
    NSString * token;
}

@property (nonatomic, retain) NSObject<TicketDataSourceDelegate> * delegate;

-(id)initWithService:(LighthouseApiService *)service;

- (void)fetchTicketsWithQuery:(NSString *)aFilterString page:(NSUInteger)page;
- (void)fetchTicketWithKey:(TicketKey *)aTicketKey;

- (void)createTicketWithDescription:(NewTicketDescription *)desc
    forProject:(id)projectKey;
- (void)editTicketWithKey:(id)key description:(UpdateTicketDescription *)desc
    forProject:(id)projectKey;
- (void)deleteTicketWithKey:(id)key forProject:(id)projectKey;

@end
