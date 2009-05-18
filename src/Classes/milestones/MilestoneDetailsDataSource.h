//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MilestoneDetailsDataSourceDelegate.h"
#import "LighthouseApiServiceDelegate.h"

@class LighthouseApiService;
@class TicketCache, MilestoneCache;

@interface MilestoneDetailsDataSource : NSObject <LighthouseApiServiceDelegate>
{
    id<MilestoneDetailsDataSourceDelegate> delegate;

    TicketCache * ticketCache;
    MilestoneCache * milestoneCache;

    id projectKey;
    id milestoneKey;

    NSMutableDictionary * cachedQueries;

    LighthouseApiService * service;
}

@property (nonatomic, retain) id<MilestoneDetailsDataSourceDelegate> delegate;

#pragma mark Initialization

- (id)initWithLighthouseApiService:(LighthouseApiService *)aService
                       ticketCache:(TicketCache *)aTicketCache
                    milestoneCache:(MilestoneCache *)aMilestoneCache;

#pragma mark Updating data

- (BOOL)fetchIfNecessary:(NSString *)queryString milestoneKey:(id)milestoneKey
    projectKey:(id)projectKey;

@end
