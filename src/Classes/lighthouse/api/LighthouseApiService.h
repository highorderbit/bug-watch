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

@end
