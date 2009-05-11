//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiServiceDelegate.h"
#import "LighthouseApiDelegate.h"

@class LighthouseApi, LighthouseApiParser;

@interface LighthouseApiService : NSObject <LighthouseApiDelegate>
{
    id<LighthouseApiServiceDelegate> delegate;

    LighthouseApi * api;
    LighthouseApiParser * parser;
}

@property (nonatomic, assign) id<LighthouseApiServiceDelegate> delegate;

#pragma mark Initialization

- (id)initWithBaseUrlString:(NSString *)aBaseUrlString;

#pragma mark Fetching tickets

- (void)fetchTicketsForAllProjects:(NSString *)token;

#pragma mark Fetching milestones

- (void)fetchMilestonesForAllProjects:(NSString *)token;
    
@end
