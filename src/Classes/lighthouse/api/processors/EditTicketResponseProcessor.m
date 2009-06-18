//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "EditTicketResponseProcessor.h"
#import "UpdateTicketDescription.h"

@interface EditTicketResponseProcessor ()

@property (nonatomic, copy) id ticketKey;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) UpdateTicketDescription * description;
@property (nonatomic, assign) id delegate;

@end

@implementation EditTicketResponseProcessor

@synthesize ticketKey, projectKey, description, delegate;

#pragma mark Instantiation and initialization

+ (id)processorWithTicketKey:(id)aTicketKey
                  projectKey:(id)aProjectKey
                 description:(UpdateTicketDescription *)aDescription
                    delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithTicketKey:aTicketKey
                                          projectKey:aProjectKey
                                         description:aDescription
                                            delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.ticketKey = nil;
    self.projectKey = nil;
    self.description = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithTicketKey:(id)aTicketKey
             projectKey:(id)aProjectKey
            description:(UpdateTicketDescription *)aDescription
               delegate:(id)aDelegate
{
    if (self = [super init]) {
        self.ticketKey = aTicketKey;
        self.projectKey = aProjectKey;
        self.description = aDescription;
        self.delegate = aDelegate;
    }

    return self;
}

#pragma mark Processing responses

- (void)processResponse:(NSData *)response
{
    SEL sel = @selector(editedTicket:forProject:describedBy:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey, projectKey,
        description, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToEditTicket:forProject:describedBy:errors:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey, projectKey,
        description, errors, nil];
}

@end
