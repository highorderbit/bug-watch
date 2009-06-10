//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LighthouseApiDelegate

#pragma mark Tickets -- searching

- (void)tickets:(NSData *)xml fetchedForAllProjectsWithToken:(NSString *)token
    requestId:(id)requestId;
- (void)failedToFetchTicketsForAllProjects:(NSString *)token
    requestId:(id)requestId error:(NSError *)error;

- (void)details:(NSData *)xml fetchedForTicket:(id)ticketKey
    inProject:(id)projectKey token:(NSString *)token requestId:(id)requestId;
- (void)failedToFetchTicketDetailsForTicket:(id)ticketKey
    inProject:(id)projectKey token:(NSString *)token requestId:(id)requestId
    error:(NSError *)error;

- (void)searchResults:(NSData *)xml
    fetchedForAllProjectsWithSearchString:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token requestId:(id)requestId;
- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page token:(NSString *)token requestId:(id)requestId
    error:(NSError *)error;

- (void)searchResults:(NSData *)xml fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token requestId:(id)requestId;
- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object token:(NSString *)token requestId:(id)requestId
    error:(NSError *)error;

#pragma mark Tickets -- creating

- (void)ticketCreationDidBegin:(NSData *)xml forProject:(id)projectKey
    object:(id)object token:(NSString *)token requestId:(id)requestId;
- (void)failedToBeginTicketCreationForProject:(id)projectKey
    object:(id)object token:(NSString *)token requestId:(id)requestId
    error:(NSError *)error;

- (void)ticketCreated:(NSData *)xml description:(NSString *)description
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId;
- (void)failedToCompleteTicketCreation:(NSString *)description
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error;

#pragma mark Tickets -- editing

- (void)editedTicket:(id)ticketKey forProject:(id)projectKey
    withDescription:(NSString *)description object:(id)object
    response:(NSData *)xml token:(NSString *)token requestId:(id)requestId;
- (void)failedToEditTicket:(id)ticketKey forProject:(id)projectKey
    description:(NSString *)desc object:(id)object token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error;

#pragma mark Tickets -- deleting

- (void)deletedTicket:(id)ticketKey forProject:(id)projectKey
    response:(NSData *)response token:(NSString *)token requestId:(id)requestId;
- (void)failedToDeleteTicket:(id)ticketKey forProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId error:(NSError *)response;

#pragma mark Ticket bins

- (void)ticketBins:(NSData *)xml fetchedForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId;
- (void)failedToFetchTicketBinsForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error;

#pragma mark Users

- (void)allUsers:(NSData *)xml fetchedForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId;
- (void)failedToFetchAllUsersForProject:(id)projectKey token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error;

#pragma mark Projects

- (void)projects:(NSData *)xml fetchedForAllProjects:(NSString *)token
    requestId:(id)requestId;
- (void)failedToFetchAllProjects:(NSString *)token requestId:(id)requestId
    error:(NSError *)error;

#pragma mark Milestones

- (void)milestones:(NSData *)xml
    fetchedForAllProjectsWithToken:(NSString *)token requestId:(id)requestId;
- (void)failedToFetchMilestonesForAllProjects:(NSString *)token
    requestId:(id)requestId error:(NSError *)error;

#pragma mark Messages

- (void)messages:(NSData *)xml fetchedForProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId;
- (void)failedToFetchMessagesForProject:(id)projectKey token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error;

- (void)comments:(NSData *)xml fetchedForMessage:(id)messageKey
    inProject:(id)projectKey token:(NSString *)token requestId:(id)requestId;
- (void)failedToFetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error;

#pragma mark Messages -- creating

- (void)message:(NSData *)response createdForProject:(id)projectKey
    withDescription:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId;
- (void)failedToCreateMessageForProject:(id)projectKey
    withDescription:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error;

#pragma mark Messages -- editing

- (void)editedMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId response:(NSData *)xml;
- (void)failedToEditMessage:(id)messageKey forProject:(id)projectKey
    description:(NSString *)description object:(id)object
    token:(NSString *)token requestId:(id)requestId error:(NSError *)error;

#pragma mark Messages -- adding comments

- (void)addedComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId response:(NSData *)xml;
- (void)failedToAddComment:(NSString *)comment toMessage:(id)messageKey
    forProject:(id)projectKey object:(id)object token:(NSString *)token
    requestId:(id)requestId error:(NSError *)error;

@end
