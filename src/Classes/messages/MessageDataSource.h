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
}

@property (nonatomic, assign) NSObject<MessageDataSourceDelegate> * delegate;

- (id)initWithService:(LighthouseApiService *)service;
- (void)fetchMessagesForProject:(NSNumber *)projectKey;
- (void)fetchCommentsForMessage:(LighthouseKey *)messageKey;
- (void)createMessageWithDescription:(NewMessageDescription *)desc
    forProject:(NSNumber *)projectKey;
- (void)setCredentials:(LighthouseCredentials *)someCredentials;

@end
