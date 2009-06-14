//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseCredentials.h"

@protocol LighthouseAccountAuthenticatorDelegate

- (void)authenticatedAccount:(LighthouseCredentials *)credentials;
- (void)failedToAuthenticateAccount:(LighthouseCredentials *)credentials
                             errors:(NSArray *)errors;

@end
