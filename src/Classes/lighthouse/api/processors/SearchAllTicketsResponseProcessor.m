//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "SearchAllTicketsResponseProcessor.h"

@interface SearchAllTicketsResponseProcessor ()

@property (nonatomic, copy) id projectKey;
@property (nonatomic, copy) NSString * searchString;
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, retain) id object;
@property (nonatomic, assign) id<LighthouseApiServiceDelegate> delegate;

@end

@implementation SearchAllTicketsResponseProcessor

@synthesize projectKey, searchString, page, object, delegate;

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

+ (id)processorWithBuilder:(BugWatchObjectBuilder *)aBuilder
                projectKey:(id)aProjectKey
              searchString:(NSString *)aSearchString
                      page:(NSUInteger)aPage
                    object:(id)anObject
                  delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    id obj = [[[self class] alloc] initWithBuilder:aBuilder
                                        projectKey:aProjectKey
                                      searchString:aSearchString
                                              page:aPage
                                            object:anObject
                                          delegate:aDelegate];
    return [obj autorelease];
}

- (void)dealloc
{
    self.projectKey = nil;
    self.searchString = nil;
    self.page = 0;
    self.object = nil;
    self.delegate = nil;
    [super dealloc];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
         searchString:(NSString *)aSearchString
                 page:(NSUInteger)aPage
             delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    return [self initWithBuilder:aBuilder
                      projectKey:nil
                    searchString:aSearchString
                            page:aPage
                          object:nil
                        delegate:aDelegate];
}

- (id)initWithBuilder:(BugWatchObjectBuilder *)aBuilder
           projectKey:(id)aProjectKey
         searchString:(NSString *)aSearchString
                 page:(NSUInteger)aPage
               object:(id)anObject
             delegate:(id<LighthouseApiServiceDelegate>)aDelegate
{
    if (self = [super initWithBuilder:aBuilder]) {
        self.projectKey = aProjectKey;
        self.searchString = aSearchString;
        self.page = aPage;
        self.object = anObject;
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
    NSArray * userKeys = [self.objectBuilder parseTicketUserKeys:xml];
    NSArray * creatorIds = [self.objectBuilder parseCreatorIds:xml];

    if (projectKey) {
        SEL sel = @selector(tickets:fetchedForProject:searchString:page:object:\
            metadata:ticketNumbers:milestoneIds:projectIds:userIds:creatorIds:);
        if ([delegate respondsToSelector:sel])
            [delegate tickets:tickets fetchedForProject:projectKey
                searchString:searchString page:page object:object
                metadata:metadata ticketNumbers:ticketNumbers
                milestoneIds:milestoneIds projectIds:projectIds
                userIds:userKeys creatorIds:creatorIds];
    } else {
        SEL sel = @selector(tickets:fetchedForSearchString:page:metadata:\
            ticketNumbers:milestoneIds:projectIds:userIds:creatorIds:);
        if ([delegate respondsToSelector:sel])
            [delegate tickets:tickets fetchedForSearchString:searchString
                page:page metadata:metadata ticketNumbers:ticketNumbers
                milestoneIds:milestoneIds projectIds:projectIds userIds:userKeys
                creatorIds:creatorIds];
    }
}

- (void)processErrors:(NSArray *)errors foundInResponse:(NSData *)xml
{
    if (projectKey) {
        SEL sel = @selector(failedToSearchTicketsForProject:searchString:page:\
            object:error:);
        if ([delegate respondsToSelector:sel])
            [delegate failedToSearchTicketsForProject:projectKey
                searchString:searchString page:page object:object
                errors:errors];
    } else {
        SEL sel = @selector(failedToSearchTicketsForAllProjects:page:error:);
        if ([delegate respondsToSelector:sel])
            [delegate failedToSearchTicketsForAllProjects:searchString
                                                     page:page
                                                   errors:errors];
    }
}

@end
