//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "ResponseProcessor.h"
#import "NSError+InstantiationAdditions.h"

@interface ResponseProcessor ()

@property (nonatomic, retain) BugWatchObjectBuilder * objectBuilder;

@end

@implementation ResponseProcessor

@synthesize objectBuilder;

- (void)dealloc
{
    self.objectBuilder = nil;
    [super dealloc];
}

#pragma mark Initialization

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
{
    if (self = [super init])
        self.objectBuilder = aBuilder;

    return self;
}

#pragma mark Processing responses

- (void)process:(NSData *)xml
{
    NSArray * errorStrings = [self.objectBuilder parseErrors:xml];

    if (errorStrings && errorStrings.count > 0) {
        // convert error messages to NSError instances
        NSMutableArray * errors =
            [NSMutableArray arrayWithCapacity:errorStrings.count];

        // HACK: This seems to be the response the Lighthouse API provides
        // when authentication fails.
        if (errorStrings.count == 1 && ![[errorStrings lastObject] length]) {
            NSError * error = [NSError errorWithLocalizedDescription:
                NSLocalizedString(@"lighthouse.auth.failed", @"")];
            [errors addObject:error];
        } else
            for (NSString * msg in errorStrings) {
                NSError * error = [NSError errorWithLocalizedDescription:msg];
                [errors addObject:error];
            }

        [self processErrors:errors foundInResponse:xml];
    } else
        [self processResponse:xml];
}

- (void)processError:(NSError *)error
{
    [self processErrors:[NSArray arrayWithObject:error] foundInResponse:nil];
}

#pragma mark Protected interface implemented by subclasses

- (void)processResponse:(NSData *)response
{
    NSAssert(NO, @"This method must be implemented by subclasses.");
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    NSAssert(NO, @"This method must be implemented by subclasses.");
}

#pragma mark Helper methods provided to subclasses

- (BOOL)invokeSelector:(SEL)selector withTarget:(id)target
    args:(id)firstArg, ...
{
    if ([target respondsToSelector:selector]) {
        NSMethodSignature * sig = [target methodSignatureForSelector:selector];
        NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setTarget:target];
        [inv setSelector:selector];

        va_list args;
        va_start(args, firstArg);
        NSInteger argIdx = 2;

        for (id arg = firstArg; arg != nil; arg = va_arg(args, id), ++argIdx)
            [inv setArgument:&arg atIndex:argIdx];

        va_end(args);

        [inv invoke];

        return YES;
    }

    return NO;
}

@end
