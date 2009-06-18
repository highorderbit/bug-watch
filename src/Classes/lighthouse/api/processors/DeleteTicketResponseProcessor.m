//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "DeleteTicketResponseProcessor.h"

@interface DeleteTicketResponseProcessor ()

@property (nonatomic, copy) id ticketKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@end

@implementation DeleteTicketResponseProcessor

@synthesize ticketKey, projectKey, delegate;

+ (id)processorWithTicketKey:(id)aTicketKey
                  projectKey:(id)aProjectKey
                    delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithTicketKey:aTicketKey
                                          projectKey:aProjectKey
                                            delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.ticketKey = nil;
    self.projectKey = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithTicketKey:(id)aTicketKey
             projectKey:(id)aProjectKey
               delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.ticketKey = aTicketKey;
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponse:(NSData *)xml
{
    SEL sel = @selector(deletedTicket:forProject:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey, projectKey,
        nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToDeleteTicket:forProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey, projectKey,
        errors, nil];
}

@end
