//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseCredentials.h"
#import "NSString+UrlEncodingAdditions.h"

@interface NSString (URLEncodingAdditions)

- (NSString *)urlEncodedString;

@end

@implementation NSString (URLEncodingAdditions)

- (NSString *)urlEncodedString
{
    return
        [self stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

@end

@interface TokenLighthouseCredentials : LighthouseCredentials <NSCopying>
{
    NSString * token;
}

- (id)initWithToken:(NSString *)aToken;

- (NSURL *)authenticateUrl:(NSURL *)url;

@end

@implementation TokenLighthouseCredentials

- (void)dealloc
{
    [token release];
    [super dealloc];
}

- (id)initWithToken:(NSString *)aToken
{
    if (self = [super init])
        token = [aToken copy];

    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (NSString *)description
{
    return token;
}

- (NSURL *)authenticateUrl:(NSURL *)url
{
    NSString * args = [url parameterString];
    NSMutableString * urlString = [[url absoluteString] mutableCopy];

    if (args.length > 0)
        [urlString appendFormat:@"&_token=%@", token];
    else
        [urlString appendFormat:@"?_token=%@", token];

    return [NSURL URLWithString:urlString];
}

@end

@interface UsernameLighthouseCredentials : LighthouseCredentials <NSCopying>
{
    NSString * username;
    NSString * password;
}

- (id)initWithUsername:(NSString *)aUsername password:(NSString *)aPassword;

- (NSURL *)authenticateUrl:(NSURL *)url;

@end

@implementation UsernameLighthouseCredentials : LighthouseCredentials

- (void)dealloc
{
    [username release];
    [password release];
    [super dealloc];
}

- (id)initWithUsername:(NSString *)aUsername password:(NSString *)aPassword
{
    if (self = [super init]) {
        username = [aUsername copy];
        password = [aPassword copy];
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@/********", username];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (NSURL *)authenticateUrl:(NSURL *)url
{
    NSString * allowedChars = @":@/?";
    NSMutableString * authString =
        [[username urlEncodedStringWithEscapedAllowedCharacters:allowedChars]
        mutableCopy];
    [authString appendString:@":"];
    [authString appendString:
        [password urlEncodedStringWithEscapedAllowedCharacters:allowedChars]];
    [authString appendString:@"@"];
    [authString appendString:account];
    [authString appendString:@"."];

    NSMutableString * urlString = [[url absoluteString] mutableCopy];

    NSRange where = [urlString rangeOfString:
        [url.scheme stringByAppendingString:@"://"]];
    [urlString insertString:authString atIndex:where.length];

    NSURL * authenticatedUrl = [NSURL URLWithString:urlString];

    NSAssert2([username isEqual:authenticatedUrl.user],
        @"URL username not set correctly. Should be '%@' but is '%@'.",
        username, authenticatedUrl.user);
    NSAssert([authenticatedUrl.password isEqual:password],
        @"Password not set correctly.");

    return authenticatedUrl;
}

@end

@implementation LighthouseCredentials

- (id)initWithAccount:(NSString *)anAccount
             username:(NSString *)aUsername
             password:(NSString *)aPassword
{
    if (self = [super init]) {
        account = [anAccount copy];
        impl =
            [[UsernameLighthouseCredentials alloc] initWithUsername:aUsername
                                                           password:aPassword];
        impl->account = [anAccount copy];
    }

    return self;
}

- (id)initWithAccount:(NSString *)anAccount
                token:(NSString *)aToken
{
    if (self = [super init]) {
        account = [anAccount copy];
        impl = [[TokenLighthouseCredentials alloc] initWithToken:aToken];
        impl->account = [anAccount copy];
    }

    return self;
}

- (void)dealloc
{
    [impl release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self retain];
}

- (NSURL *)authenticateUrl:(NSURL *)url
{
    return [impl authenticateUrl:url];
}

@end
