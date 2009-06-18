//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LogInResponseProcessor.h"
#import "LighthouseCredentials.h"

@interface LogInResponseProcessor ()

@property (nonatomic, copy) LighthouseCredentials * credentials;
@property (nonatomic, assign) id delegate;

@end

@implementation LogInResponseProcessor

@synthesize credentials, delegate;

+ (id)processorWithCredentials:(LighthouseCredentials *)someCredentials
                      delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithCredentials:someCredentials
                                              delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.credentials = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithCredentials:(LighthouseCredentials *)someCredentials
                 delegate:(id)aDelegate
{
    if (self = [super init]) {
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
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToAuthenticateAccount:errors:);
    [self invokeSelector:sel
              withTarget:self.delegate
                    args:self.credentials, errors, nil];
}

@end
