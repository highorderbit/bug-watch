//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseApiDelegate.h"
#import "LighthouseCredentials.h"
#import "LighthouseAccountAuthenticatorDelegate.h"

@class LighthouseApi, BugWatchObjectBuilder;

@interface LighthouseAccountAuthenticator : NSObject <LighthouseApiDelegate>
{
    id<LighthouseAccountAuthenticatorDelegate> delegate;

    NSString * lighthouseDomain;
    NSString * lighthouseScheme;

    NSMutableDictionary * apis;
    NSMutableDictionary * processors;

    BugWatchObjectBuilder * builder;
}

@property (nonatomic, assign) id<LighthouseAccountAuthenticatorDelegate>
    delegate;

- (id)initWithLighthouseDomain:(NSString *)domain
                        scheme:(NSString *)scheme;

- (void)authenticateCredentials:(LighthouseCredentials *)credentials;

@end
