//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LighthouseCredentials : NSObject <NSCopying>
{
    NSString * account;
    LighthouseCredentials * impl;
}

+ (id)credentialsWithAccount:(NSString *)anAccount
                    username:(NSString *)aUsername
                    password:(NSString *)aPassword;
+ (id)credentialsWithAccount:(NSString *)anAccount token:(NSString *)aToken;

- (id)initWithAccount:(NSString *)anAccount
             username:(NSString *)aUsername
             password:(NSString *)aPassword;
- (id)initWithAccount:(NSString *)anAccount token:(NSString *)aToken;

- (NSURL *)authenticateUrl:(NSURL *)url;

- (void)saveToPlist:(NSString *)plist;
+ (id)loadFromPlist:(NSString *)plist;

@end
