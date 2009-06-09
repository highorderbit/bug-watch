//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDataSourceDelegate.h"
#import "LighthouseApiService.h"
#import "LighthouseApiServiceDelegate.h"
#import "NewMessageDescription.h"

@interface MessageDataSource : NSObject <LighthouseApiServiceDelegate>
{
    NSObject<MessageDataSourceDelegate> * delegate;
    LighthouseApiService * service;
    NSString * token;
}

@property (nonatomic, assign) NSObject<MessageDataSourceDelegate> * delegate;
@property (nonatomic, copy) NSString * token;

- (id)initWithService:(LighthouseApiService *)service;
- (void)fetchMessagesForProject:(id)projectKey;
- (void)createMessageWithDescription:(NewMessageDescription *)desc
    forProject:(id)projectKey;

@end
