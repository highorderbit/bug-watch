//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "CreateTicketResponseProcessor.h"
#import "NewTicketDescription.h"
#import "RegexKitLite.h"

@interface CreateTicketResponseProcessor ()

@property (nonatomic, copy) NewTicketDescription * description;
@property (nonatomic, copy) id projectKey;
@property (nonatomic, assign) id delegate;

@end

@implementation CreateTicketResponseProcessor

@synthesize description, projectKey, delegate;

#pragma mark Instantiation and initialization

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
               description:(NewTicketDescription *)aDescription
                projectKey:(id)aProjectKey
                  delegate:(id)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                       description:aDescription
                                        projectKey:aProjectKey
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.description = nil;
    self.projectKey = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
          description:(NewTicketDescription *)aDescription
           projectKey:(id)aProjectKey
             delegate:(id)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.description = aDescription;
        self.projectKey = aProjectKey;
        self.delegate = aDelegate;
    }

    return self;
}

#pragma mark Processing responses

- (void)processResponse:(NSData *)response
{
    NSArray * ticketUrls = [self.objectBuilder parseTicketUrls:response];

    NSString * url = [ticketUrls lastObject];
    id ticketKey = [url stringByMatching:@".*/(\\d+)$" capture:1];

    SEL sel = @selector(ticket:describedBy:createdForProject:);
    [self invokeSelector:sel withTarget:delegate args:ticketKey,
        description, projectKey, nil];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToCreateNewTicketDescribedBy:forProject:errors:);
    [self invokeSelector:sel withTarget:delegate args:description,
        projectKey, errors, nil];
}

@end
