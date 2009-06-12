//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInState.h"

@interface LogInState ()

@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;

@end

@implementation LogInState

@synthesize account, username, password;

- (void)dealloc
{
    [self clear];
    [super dealloc];
}

- (id)init
{
    return (self = [super init]);
}

#pragma mark NSCopying implementation

- (id)copyWithZone:(NSZone *)zone
{
    LogInState * copy = [[LogInState allocWithZone:zone] init];

    copy.account = self.account;
    copy.username = self.username;
    copy.password = self.password;

    return copy;
}

- (void)setAccount:(NSString *)anAccount
          username:(NSString *)aUsername
          password:(NSString *)aPassword
{
    self.account = anAccount;
    self.username = aUsername;
    self.password = aPassword;
}

- (void)clear
{
    self.account = nil;
    self.username = nil;
    self.password = nil;
}

@end
