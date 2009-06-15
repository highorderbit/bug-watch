//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageDisplayMgr.h"
#import "LighthouseApiServiceFactory.h"

@interface MessageDisplayMgrFactory : NSObject
{
    LighthouseApiServiceFactory * lighthouseApiFactory;
}

- (id)initWithLighthouseApiFactory:
    (LighthouseApiServiceFactory *)lighthouseApiFactory;

- (MessageDisplayMgr *)createMessageDisplayMgrWithCache:(MessageCache *)cache
    wrapperController:(NetworkAwareViewController *)wrapperController;

@end
