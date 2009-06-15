//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiServiceDelegate.h"
#import "LighthouseApiDelegate.h"

#import "LighthouseUrlBuilder.h"
#import "LighthouseCredentials.h"

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

- (id)initWithUrlBuilder:(LighthouseUrlBuilder *)urlBuilder;
- (id)initWithUrlBuilder:(LighthouseUrlBuilder *)urlBuilder
             credentials:(LighthouseCredentials *)credentials;

#pragma mark Work with credentials

- (void)setCredentials:(LighthouseCredentials *)credentials;

#pragma mark Tickets -- searching

- (void)fetchTicketsForAllProjects;

- (void)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey;

- (void)searchTicketsForAllProjects:(NSString *)searchString
                               page:(NSUInteger)page;
- (void)searchTicketsForProject:(id)projectKey
               withSearchString:(NSString *)searchString
                           page:(NSUInteger)page
                         object:(id)object;

#pragma mark Tickets -- creating

- (void)createNewTicket:(NewTicketDescription *)desc forProject:(id)projectKey;

#pragma mark Tickets -- editing

- (void)editTicket:(id)ticketKey
        forProject:(id)projectKey
   withDescription:(UpdateTicketDescription *)desc;

#pragma mark Tickets -- deleting

- (void)deleteTicket:(id)ticketKey forProject:(id)projectKey;

#pragma mark Ticket bins

- (void)fetchTicketBinsForProject:(id)projectKey;

#pragma mark Users

- (void)fetchAllUsersForProject:(id)projectKey;

#pragma mark Projects

- (void)fetchAllProjects;

#pragma mark Milestones

- (void)fetchMilestonesForAllProjects;

#pragma mark Messages

- (void)fetchMessagesForProject:(id)projectKey;
- (void)fetchCommentsForMessage:(id)messageKey inProject:(id)projectKey;

#pragma mark Messages -- creating

- (void)createMessage:(NewMessageDescription *)desc forProject:(id)projectKey;

#pragma mark Messages -- editing

- (void)editMessage:(id)messageKey
         forProject:(id)projectKey
    withDescription:(UpdateMessageDescription *)desc;

#pragma mark Messages -- adding comments

- (void)addComment:(NewMessageCommentDescription *)desc
         toMessage:(id)messageKey
        forProject:(id)projectKey;

#pragma mark Notification names posted to the application as data is received

+ (NSString *)milestonesReceivedForAllProjectsNotificationName;
+ (NSString *)usersRecevedForProjectNotificationName;
+ (NSString *)allProjectsReceivedNotificationName;
    
@end
