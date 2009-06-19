//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewTicketDescription, UpdateTicketDescription;
@class NewMessageDescription, UpdateMessageDescription;
@class NewMessageCommentDescription;
@class MessageResponse;
@class Ticket, TicketMetaData;

@protocol LighthouseApiServiceDelegate <NSObject>

#pragma mark Fetching tickets

@optional

- (void)tickets:(NSArray *)tickets
    fetchedForAllProjectsWithMetadata:(NSArray *)metadata
    ticketNumbers:(NSArray *)ticketNumbers milestoneIds:(NSArray *)milestoneIds
    projectIds:(NSArray *)projectIds userIds:(NSArray *)userIds
    creatorIds:(NSArray *)creatorIds;
- (void)failedToFetchTicketsForAllProjects:(NSArray *)errors;

- (void)details:(NSArray *)detais authors:(NSArray *)authors
    ticket:(Ticket *)ticket metadata:(TicketMetaData *)metadata
    fetchedForTicket:(id)ticketKey inProject:(id)projectKey;
- (void)failedToFetchTicketDetailsForTicket:(id)ticketKey
    inProject:(id)projectKey errors:(NSArray *)errors;

- (void)tickets:(NSArray *)tickets
    fetchedForSearchString:(NSString *)searchString page:(NSUInteger)page
    metadata:(NSArray *)metadata ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds projectIds:(NSArray *)projectIds
    userIds:(NSArray *)userIds creatorIds:(NSArray *)creatorIds;
- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page errors:(NSArray *)errors;

- (void)tickets:(NSArray *)tickets fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object metadata:(NSArray *)metadata
    ticketNumbers:(NSArray *)ticketNumbers milestoneIds:(NSArray *)milestoneIds
    projectIds:(NSArray *)projectIds userIds:(NSArray *)userIds
    creatorIds:(NSArray *)creatorIds;
- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object errors:(NSArray *)errors;

#pragma mark Tickets -- creating

- (void)ticket:(id)ticketKey describedBy:(NewTicketDescription *)description
    createdForProject:(id)projectKey;
- (void)failedToCreateNewTicketDescribedBy:(NewTicketDescription *)description
    forProject:(id)projectKey errors:(NSArray *)errors;

#pragma mark Tickets -- editing

- (void)editedTicket:(id)ticketKey forProject:(id)projectKey
    describedBy:(UpdateTicketDescription *)description;
- (void)failedToEditTicket:(id)ticketKey forProject:(id)projectKey
    describedBy:(UpdateTicketDescription *)description errors:(NSArray *)errors;

#pragma mark Tickets -- deleting

- (void)deletedTicket:(id)ticketKey forProject:(id)projectKey;
- (void)failedToDeleteTicket:(id)ticketKey forProject:(id)projectKey
    errors:(NSArray *)errors;

#pragma mark Ticket bins

@optional

- (void)fetchedTicketBins:(NSArray *)ticketBins forProject:(id)projectKey;
- (void)failedToFetchTicketBinsForProject:(id)projectKey
    errors:(NSArray *)errors;

#pragma mark Users

@optional

- (void)allUsers:(NSDictionary *)users fetchedForProject:(id)projectKey;
- (void)failedToFetchAllUsersForProject:(id)projectKey errors:(NSArray *)errors;

#pragma mark Projects

@optional

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;
- (void)failedToFetchAllProjects:(NSArray *)errors;

#pragma mark Fetching milestones

@optional

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones;
- (void)failedToFetchMilestonesForAllProjects:(NSArray *)errors;

#pragma mark Messages

@optional

- (void)messages:(NSArray *)messages messageKeys:(NSArray *)messageKeys
    authorKeys:(NSArray *)authorKeys fetchedForProject:(id)projectKey;
- (void)failedToFetchMessagesForProject:(id)projectKey errors:(NSArray *)errors;

- (void)comments:(NSArray *)comments commentKeys:(NSArray *)commentKeys
    authorKeys:(NSArray *)authorKeys fetchedForMessage:(id)messageKey
    inProject:(id)projectKey;
- (void)failedToFetchCommentsForMessage:(id)messageKey inProject:(id)projectKey
    errors:(NSArray *)errors;

#pragma mark Messages -- creating

- (void)message:(id)messageKey describedBy:(NewMessageDescription *)desc
    createdForProject:(id)projectKey;
- (void)failedToCreateMessageDescribedBy:(NewMessageDescription *)desc
    forProject:(id)projectKey errors:(NSArray *)errors;

#pragma mark Messages -- editing

- (void)editedMessage:(id)messageKey forProject:(id)projectKey
    describedBy:(UpdateMessageDescription *)description;
- (void)failedToEditMessage:(id)messageKey forProject:(id)projectKey
    describedBy:(UpdateMessageDescription *)description
    errors:(NSArray *)errors;

#pragma mark Messages -- adding comments

- (void)comment:(MessageResponse *)comment withKey:(id)commentKey
    authorKey:(id)authorKey addedToMessage:(id)messageKey
    forProject:(id)projectKey describedBy:(NewMessageCommentDescription *)desc;
- (void)failedToAddCommentToMessage:(id)messageKey forProject:(id)projectKey
    describedBy:(NewMessageDescription *)desc errors:(NSArray *)errors;

@end
