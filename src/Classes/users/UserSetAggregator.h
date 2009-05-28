//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiService.h"
#import "LighthouseApiServiceDelegate.h"

@interface UserSetAggregator : NSObject <LighthouseApiServiceDelegate>
{
    id listener;
    SEL action;

    LighthouseApiService * service;
    NSString * token;

    NSUInteger outstandingRequests;
    NSMutableDictionary * users;
}

@property (nonatomic, retain) NSMutableDictionary * users;

//
// The selector provided should have the same arguments as:
//   - (void)fetchedAllUsers:(NSDictionary *)users;
//
- (id)initWithListener:(id)listener action:(SEL)action
    apiService:(LighthouseApiService *)service token:(NSString *)token;

- (void)fetchedAllProjects:(NSArray *)projects projectKeys:(NSArray *)keys;

@end
