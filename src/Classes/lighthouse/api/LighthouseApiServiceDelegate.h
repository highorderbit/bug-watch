//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewTicketDescription;

@protocol LighthouseApiServiceDelegate <NSObject>

#pragma mark Fetching tickets

@optional

- (void)tickets:(NSArray *)tickets
    fetchedForAllProjectsWithMetadata:(NSArray *)metadata
    ticketNumbers:(NSArray *)ticketNumbers milestoneIds:(NSArray *)milestoneIds
    projectIds:(NSArray *)projectIds userIds:(NSArray *)userIds
    creatorIds:(NSArray *)creatorIds;
- (void)failedToFetchTicketsForAllProjects:(NSError *)error;

- (void)details:(NSArray *)detais authors:(NSArray *)authors
    fetchedForTicket:(id)ticketKey inProject:(id)projectKey;
- (void)failedToFetchTicketDetailsForTicket:(id)ticketKey
    inProject:(id)projectKey error:(NSError *)error;

- (void)tickets:(NSArray *)tickets
    fetchedForSearchString:(NSString *)searchString
    metadata:(NSArray *)metadata ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds projectIds:(NSArray *)projectIds
    userIds:(NSArray *)userIds creatorIds:(NSArray *)creatorIds;
- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    error:(NSError *)error;

- (void)tickets:(NSArray *)tickets fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString object:(id)object
    metadata:(NSArray *)metadata ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds projectIds:(NSArray *)projectIds
    userIds:(NSArray *)userIds creatorIds:(NSArray *)creatorIds;
- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString object:(id)object
    error:(NSError *)error;

#pragma mark Tickets -- creating

- (void)ticket:(id)ticketKey describedBy:(NewTicketDescription *)description
    createdForProject:(id)projectKey;
- (void)failedToCreateNewTicketDescribedBy:(NewTicketDescription *)description
    forProject:(id)projectKey error:(NSError *)error;

#pragma mark Tickets -- editing

- (void)editedTicket:(id)ticketKey forProject:(id)projectKey
    describedBy:(NewTicketDescription *)description;
- (void)failedToEditTicket:(id)ticketKey forProject:(id)projectKey
    describedBy:(NewTicketDescription *)description error:(NSError *)error;

#pragma mark Ticket bins

@optional

- (void)fetchedTicketBins:(NSArray *)ticketBins token:(NSString *)token;
- (void)failedToFetchTicketBins:(NSString *)token error:(NSError *)error;

#pragma mark Users

@optional

- (void)allUsers:(NSDictionary *)users fetchedForProject:(id)projectKey;
- (void)failedToFetchAllUsersForProject:(id)projectKey error:(NSError *)error;

#pragma mark Projects

@optional

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;
- (void)failedToFetchAllProjects:(NSError *)error;

#pragma mark Fetching milestones

@optional

- (void)milestonesFetchedForAllProjects:(NSArray *)milestones;
- (void)failedToFetchMilestonesForAllProjects:(NSError *)error;

@end
