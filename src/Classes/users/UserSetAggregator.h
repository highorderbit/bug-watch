//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"
#import "LighthouseApiServiceDelegate.h"

@interface UserSetAggregator : NSObject <LighthouseApiServiceDelegate>
{
    LighthouseApiService * service;
    NSString * token;

    NSUInteger outstandingRequests;
    NSMutableDictionary * users;
}

@property (nonatomic, retain) NSMutableDictionary * users;

- (id)initWithApiService:(LighthouseApiService *)service
    token:(NSString *)token;

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;

+ (NSString *)allUsersReceivedNotificationName;

@end
