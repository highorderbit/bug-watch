//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDisplayMgr.h"
#import "LighthouseApiServiceFactory.h"

@interface MessageDisplayMgrFactory : NSObject
{
    NSString * apiToken;
    LighthouseApiServiceFactory * lighthouseApiFactory;
}

- (id)initWithApiToken:(NSString *)apiToken
    lighthouseApiFactory:(LighthouseApiServiceFactory *)lighthouseApiFactory;

- (MessageDisplayMgr *)createMessageDisplayMgrWithCache:(MessageCache *)cache
    wrapperController:(NetworkAwareViewController *)wrapperController;

@end
