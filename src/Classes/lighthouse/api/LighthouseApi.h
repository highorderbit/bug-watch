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

    NSMutableDictionary * arguments;
}

@property (nonatomic, assign) id<LighthouseApiDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString;

#pragma mark Tickets -- retrieving and searching

- (id)fetchTicketsForAllProjects:(NSString *)token;

- (id)fetchDetailsForTicket:(id)ticketKey inProject:(id)projectKey
    token:(NSString *)token;

- (id)searchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token;
- (id)searchTicketsForProject:(id)projectKey
    withSearchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token;

#pragma mark Tickets -- creating

- (id)beginTicketCreationForProject:(id)projectKey object:(id)object
    token:(NSString *)token;

- (id)completeTicketCreationForProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token;

#pragma mark Tickets -- editing

- (id)editTicket:(id)ticketKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token;

#pragma mark Tickets -- deleting

- (id)deleteTicket:(id)ticketKey forProject:(id)projectKey
    token:(NSString *)token;

#pragma mark Ticket bins

- (id)fetchTicketBinsForProject:(id)projectKey token:(NSString *)token;

#pragma mark Users

- (id)fetchAllUsersForProject:(id)projectKey token:(NSString *)token;

#pragma mark Projects

- (id)fetchAllProjects:(NSString *)token;

#pragma mark Milestones

- (id)fetchMilestonesForAllProjects:(NSString *)token;

#pragma mark Messages

- (id)fetchMessagesForProject:(id)projectKey token:(NSString *)token;
- (id)fetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    token:(NSString *)token;

#pragma mark Messages -- creating

- (id)createMessageForProject:(id)projectKey description:(NSString *)description
    object:(id)object token:(NSString *)token;

#pragma mark Messages -- editing

- (id)editMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token;

#pragma mark Messages -- adding comments

- (id)addComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey object:(id)object token:(NSString *)token;

@end
