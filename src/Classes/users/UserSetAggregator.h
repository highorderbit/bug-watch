//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"
#import "LighthouseApiServiceDelegate.h"

@interface UserSetAggregator : NSObject <LighthouseApiServiceDelegate>
{
    LighthouseApiService * service;

    NSUInteger outstandingRequests;
    NSMutableDictionary * users;
}

@property (nonatomic, retain) NSMutableDictionary * users;

- (id)initWithApiService:(LighthouseApiService *)service;

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;

+ (NSString *)allUsersReceivedNotificationName;

@end
