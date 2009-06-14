//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LighthouseCredentials : NSObject <NSCopying>
{
    NSString * account;
    LighthouseCredentials * impl;
}

- (id)initWithAccount:(NSString *)anAccount
             username:(NSString *)aUsername
             password:(NSString *)aPassword;
- (id)initWithAccount:(NSString *)anAccount token:(NSString *)aToken;

- (NSURL *)authenticateUrl:(NSURL *)url;

@end
