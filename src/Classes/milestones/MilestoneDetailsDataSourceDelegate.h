//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Milestone;

@protocol MilestoneDetailsDataSourceDelegate

- (void)fetchDidBegin;
- (void)fetchDidEnd;

- (void)tickets:(NSDictionary *)tickets fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString metadata:(NSDictionary *)metadata
    milestone:(Milestone *)milestone userIds:(NSDictionary *)userIds
    creatorIds:(NSDictionary *)creatorIds;
- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString error:(NSError *)error;

@end
