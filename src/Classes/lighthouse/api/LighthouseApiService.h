//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiServiceDelegate.h"
#import "LighthouseApiDelegate.h"
#import "NewTicketDescription.h"

@class LighthouseApi, LighthouseApiParser;

@interface LighthouseApiService : NSObject <LighthouseApiDelegate>
{
    id<LighthouseApiServiceDelegate> delegate;

    LighthouseApi * api;
    LighthouseApiParser * parser;

    NSMutableDictionary * newTicketRequests;
}

@property (nonatomic, assign) id<LighthouseApiServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString;

#pragma mark Tickets

- (void)fetchTicketsForAllProjects:(NSString *)token;

- (void)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token;

- (void)searchTicketsForAllProjects:(NSString *)searchString
                              token:(NSString *)token;
- (void)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString object:(id)object
    token:(NSString *)token;

- (void)createNewTicket:(NewTicketDescription *)desc forProject:(id)projectKey
    token:(NSString *)token;

#pragma mark Ticket bins

- (void)fetchTicketBins:(NSString *)token;

#pragma mark Users

- (void)fetchAllUsersForProject:(id)projectKey token:(NSString *)token;

#pragma mark Projects

- (void)fetchAllProjects:(NSString *)token;

#pragma mark Milestones

- (void)fetchMilestonesForAllProjects:(NSString *)token;

#pragma mark Notification names posted to the application as data is received

+ (NSString *)milestonesReceivedForAllProjectsNotificationName;
+ (NSString *)usersRecevedForProjectNotificationName;
    
@end
