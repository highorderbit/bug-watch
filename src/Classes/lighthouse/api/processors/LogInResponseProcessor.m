//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInResponseProcessor.h"
#import "LighthouseCredentials.h"
#import "LighthouseAccountAuthenticator.h"

@interface LogInResponseProcessor ()

@property (nonatomic, copy) LighthouseCredentials * credentials;
@property (nonatomic, assign) id delegate;

@end

@implementation LogInResponseProcessor

@synthesize credentials, delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
               credentials:(LighthouseCredentials *)someCredentials
                  delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                       credentials:someCredentials
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.credentials = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
          credentials:(LighthouseCredentials *)someCredentials
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.credentials = someCredentials;
        self.delegate = aDelegate;
    }

    return self;
}

#pragma mark Processing responses

- (void)processResponse:(NSData *)response
{
    SEL sel = @selector(authenticatedAccount:);
    [self invokeSelector:sel
              withTarget:self.delegate
                    args:self.credentials, nil];

    // notify the system that the 'logged in' credentials have changed
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    NSDictionary * userInfo =
        [NSDictionary dictionaryWithObjectsAndKeys:
        self.credentials, @"credentials", nil];
    NSString * notificationName =
        [LighthouseAccountAuthenticator credentialsChangedNotificationName];
    [nc postNotificationName:notificationName object:self userInfo:userInfo];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToAuthenticateAccount:errors:);
    [self invokeSelector:sel
              withTarget:self.delegate
                    args:self.credentials, errors, nil];
}

@end
