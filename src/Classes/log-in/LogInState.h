//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogInState : NSObject <NSCopying>
{
    NSString * account;
    NSString * username;
    NSString * password;
}

@property (nonatomic, copy, readonly) NSString * account;
@property (nonatomic, copy, readonly) NSString * username;
@property (nonatomic, copy, readonly) NSString * password;

- (id)init;

- (void)setAccount:(NSString *)anAccount
          username:(NSString *)aUsername
          password:(NSString *)aPassword;
- (void)clear;

@end
