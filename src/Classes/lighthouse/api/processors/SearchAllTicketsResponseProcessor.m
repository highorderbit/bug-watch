//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "SearchAllTicketsResponseProcessor.h"

@interface SearchAllTicketsResponseProcessor ()

@property (nonatomic, copy) NSString * searchString;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) id<LighthouseApiServiceDelegate> delegate;

@end

@implementation SearchAllTicketsResponseProcessor

@synthesize searchString, page, delegate;

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
              searchString:(NSString *)aSearchString
                      page:(NSUInteger)aPage
                  delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                      searchString:aSearchString
                                              page:aPage
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.searchString = nil;
    self.page = 0;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
         searchString:(NSString *)aSearchString
                 page:(NSUInteger)aPage
             delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.searchString = aSearchString;
        self.page = aPage;
        self.delegate = aDelegate;
    }

    return self;
}

- (void)processResponse:(NSData *)xml
{
    NSArray * ticketNumbers = [self.objectBuilder parseTicketNumbers:xml];
    NSArray * tickets = [self.objectBuilder parseTickets:xml];
    NSArray * metadata = [self.objectBuilder parseTicketMetaData:xml];
    NSArray * milestoneIds = [self.objectBuilder parseTicketMilestoneIds:xml];
    NSArray * projectIds = [self.objectBuilder parseTicketProjectIds:xml];
    NSArray * userIds = [self.objectBuilder parseUserIds:xml];
    NSArray * creatorIds = [self.objectBuilder parseCreatorIds:xml];

    SEL sel = @selector(tickets:fetchedForSearchString:page:metadata:\
        ticketNumbers:milestoneIds:projectIds:userIds:creatorIds:);
    if ([delegate respondsToSelector:sel])
        [delegate tickets:tickets fetchedForSearchString:searchString
            page:page metadata:metadata ticketNumbers:ticketNumbers
            milestoneIds:milestoneIds projectIds:projectIds userIds:userIds
            creatorIds:creatorIds];
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    SEL sel = @selector(failedToSearchTicketsForAllProjects:page:error:);
    if ([delegate respondsToSelector:sel])
        [delegate failedToSearchTicketsForAllProjects:searchString
                                                 page:page
                                               errors:errors];
}

@end
