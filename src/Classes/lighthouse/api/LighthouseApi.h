//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiDelegate.h"
#import "WebServiceApiDelegate.h"

@class WebServiceApi, WebServiceResponseDispatcher;

@interface LighthouseApi : NSObject <WebServiceApiDelegate>
{
    id<LighthouseApiDelegate> delegate;

    NSString * baseUrlString;

    WebServiceApi * api;
    WebServiceResponseDispatcher * dispatcher;
}

@property (nonatomic, assign) id<LighthouseApiDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString;

#pragma mark Tickets -- retrieving and searching

- (void)fetchTicketsForAllProjects:(NSString *)token;

- (void)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token;

- (void)searchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token;
- (void)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token;

#pragma mark Tickets -- creating

- (void)beginTicketCreationForProject:(id)projectKey
                               object:(id)object
                                token:(NSString *)token;

- (void)completeTicketCreationForProject:(id)projectKey
                             description:(NSString *)description
                                  object:(id)object
                                   token:(NSString *)token;

#pragma mark Tickets -- editing

- (void)editTicket:(id)ticketKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token;

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

- (void)createMessageForProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token;

#pragma mark Messages -- editing

- (void)editMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token;

#pragma mark Messages -- adding comments

- (void)addComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey object:(id)object token:(NSString *)token;

@end
