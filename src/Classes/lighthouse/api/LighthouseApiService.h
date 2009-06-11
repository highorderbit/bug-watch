//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiServiceDelegate.h"
#import "LighthouseApiDelegate.h"

#import "NewTicketDescription.h"
#import "UpdateTicketDescription.h"
#import "NewMessageDescription.h"
#import "UpdateMessageDescription.h"
#import "NewMessageCommentDescription.h"

@class LighthouseApi;
@class BugWatchObjectBuilder;

@interface LighthouseApiService : NSObject <LighthouseApiDelegate>
{
    id<LighthouseApiServiceDelegate> delegate;

    LighthouseApi * api;

    BugWatchObjectBuilder * builder;

    NSMutableDictionary * responseProcessors;
}

@property (nonatomic, assign) id<LighthouseApiServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString;

#pragma mark Tickets -- searching

- (void)fetchTicketsForAllProjects:(NSString *)token;

- (void)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token;

- (void)searchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token;
- (void)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token;

#pragma mark Tickets -- creating

- (void)createNewTicket:(NewTicketDescription *)desc forProject:(id)projectKey
    token:(NSString *)token;

#pragma mark Tickets -- editing

- (void)editTicket:(id)ticketKey forProject:(id)projectKey
    withDescription:(UpdateTicketDescription *)desc token:(NSString *)token;

#pragma mark Tickets -- deleting

- (void)deleteTicket:(id)ticketKey forProject:(id)projectKey
    token:(NSString *)token;

#pragma mark Ticket bins

- (void)fetchTicketBinsForProject:(id)projectKey token:(NSString *)token;

#pragma mark Users

- (void)fetchAllUsersForProject:(id)projectKey token:(NSString *)token;

#pragma mark Projects

- (void)fetchAllProjects:(NSString *)token;

#pragma mark Milestones

- (void)fetchMilestonesForAllProjects:(NSString *)token;

#pragma mark Messages

- (void)fetchMessagesForProject:(id)projectKey token:(NSString *)token;
- (void)fetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    token:(NSString *)token;

#pragma mark Messages -- creating

- (void)createMessage:(NewMessageDescription *)desc forProject:(id)projectKey
    token:(NSString *)token;

#pragma mark Messages -- editing

- (void)editMessage:(id)messageKey forProject:(id)projectKey
    withDescription:(UpdateMessageDescription *)desc token:(NSString *)token;

#pragma mark Messages -- adding comments

- (void)addComment:(NewMessageCommentDescription *)desc toMessage:(id)messageKey
    forProject:(id)projectKey token:(NSString *)token;

#pragma mark Notification names posted to the application as data is received

+ (NSString *)milestonesReceivedForAllProjectsNotificationName;
+ (NSString *)usersRecevedForProjectNotificationName;
+ (NSString *)allProjectsReceivedNotificationName;
    
@end
