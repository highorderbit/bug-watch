//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDataSource.h"
#import "TicketCache.h"
#import "TicketCommentCache.h"
#import "TicketComment.h"
#import "NewTicketDescription.h"
#import "UpdateTicketDescription.h"
#import "TicketDiffHelpers.h"

@interface TicketDataSource (Private)

+ (TicketDiff *)parseYaml:(NSString *)yaml;
+ (NSString *)readableTextFromDiffs:(NSArray *)diffs atIndex:(NSUInteger)index;
+ (NSString *)findNextValueForKey:(NSString *)key inDiffs:(NSArray *)diffs
    fromIndex:(NSUInteger)index;

@end

@implementation TicketDataSource

@synthesize delegate;

- (void)dealloc
{
    [delegate release];
    [service release];
    [super dealloc];
}

-(id)initWithService:(LighthouseApiService *)aService
{
    if (self = [super init])
        service = [aService retain];

    return self;
}

- (void)fetchTicketsWithQuery:(NSString *)aFilterString page:(NSUInteger)page
{
    [service searchTicketsForAllProjects:aFilterString page:page];
}

- (void)fetchTicketsWithQuery:(NSString *)aFilterString page:(NSUInteger)page
    project:(id)projectKey
{
    [service searchTicketsForProject:projectKey withSearchString:aFilterString
        page:page object:nil];
}

- (void)fetchTicketWithKey:(LighthouseKey *)aTicketKey
{
    [service
        fetchDetailsForTicket:[NSNumber numberWithInt:aTicketKey.key]
        inProject:[NSNumber numberWithInt:aTicketKey.projectKey]];
}

- (void)createTicketWithDescription:(NewTicketDescription *)desc
    forProject:(id)projectKey
{
    [service createNewTicket:desc forProject:projectKey];
}

- (void)editTicketWithKey:(id)key description:(UpdateTicketDescription *)desc
    forProject:(id)projectKey
{
    NSLog(@"Sending 'edit ticket' request to api...");
    [service editTicket:key forProject:projectKey withDescription:desc];
}

- (void)deleteTicketWithKey:(NSUInteger)ticketNumber
    forProject:(NSUInteger)projectKey
{
    [service deleteTicket:[NSNumber numberWithInt:ticketNumber]
        forProject:[NSNumber numberWithInt:projectKey]];
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)tickets:(NSArray *)tickets
    fetchedForSearchString:(NSString *)searchString page:(NSUInteger)page
    metadata:(NSArray *)someMetaData ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds projectIds:(NSArray *)projectIds
    userIds:(NSArray *)userIds creatorIds:(NSArray *)creatorIds
{
    NSLog(@"Received tickets (%@ - page %d): %@", searchString, page, tickets);
    NSLog(@"Metadta: %@", someMetaData);
    NSLog(@"Ticket numbers: %@", ticketNumbers);
    NSLog(@"Milestone id's: %@", milestoneIds);
    NSLog(@"Project id's: %@", projectIds);
    NSLog(@"User id's: %@", userIds);
    NSLog(@"Creator id's: %@", creatorIds);

    // create ticket cache
    TicketCache * ticketCache = [[TicketCache alloc] init];
    for (int i = 0; i < [ticketNumbers count]; i++) {
        NSNumber * ticketNumber = [ticketNumbers objectAtIndex:i];
        NSUInteger ticketNumberAsInt = [((NSNumber *)ticketNumber) intValue];
        NSNumber * projectNumber = [projectIds objectAtIndex:i];
        NSUInteger projectNumberAsInt = [((NSNumber *)projectNumber) intValue];
        id ticketKey =
            [[[LighthouseKey alloc]
            initWithProjectKey:projectNumberAsInt
            key:ticketNumberAsInt]
            autorelease];

        Ticket * ticket = [tickets objectAtIndex:i];
        TicketMetaData * metaData = [someMetaData objectAtIndex:i];
        id milestoneId = [milestoneIds objectAtIndex:i];
        id userId = [userIds objectAtIndex:i];
        id creatorId = [creatorIds objectAtIndex:i];
        [ticketCache setTicket:ticket forKey:ticketKey];
        [ticketCache setMetaData:metaData forKey:ticketKey];
        if (userId)
            [ticketCache setAssignedToKey:userId forKey:ticketKey];
        if (milestoneId)
            [ticketCache setMilestoneKey:milestoneId forKey:ticketKey];
        if (creatorId)
            [ticketCache setCreatedByKey:creatorId forKey:ticketKey];
    }
    ticketCache.query = searchString;
    ticketCache.numPages = page;

    [delegate receivedTicketsFromDataSource:ticketCache];
}

- (void)failedToSearchTicketsForAllProjects:(NSString *)searchString
    page:(NSUInteger)page errors:(NSArray *)errors
{
    [delegate failedToFetchTickets:errors];
}

- (void)tickets:(NSArray *)tickets fetchedForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object metadata:(NSArray *)metadata
    ticketNumbers:(NSArray *)ticketNumbers milestoneIds:(NSArray *)milestoneIds
    projectIds:(NSArray *)projectIds userIds:(NSArray *)userIds
    creatorIds:(NSArray *)creatorIds
{
    [self tickets:tickets fetchedForSearchString:searchString page:page
        metadata:metadata ticketNumbers:ticketNumbers
        milestoneIds:milestoneIds projectIds:projectIds userIds:userIds
        creatorIds:creatorIds];
}

- (void)failedToSearchTicketsForProject:(id)projectKey
    searchString:(NSString *)searchString page:(NSUInteger)page
    object:(id)object errors:(NSArray *)errors
{
    [delegate failedToFetchTickets:errors];
}

- (void)details:(NSArray *)details authors:(NSArray *)authors
    fetchedForTicket:(id)ticketKey inProject:(id)projectKey
{
    NSLog(@"Received ticket details from server.");

    TicketCommentCache * commentCache =
        [[[TicketCommentCache alloc] init] autorelease];

    for (int i = 0; i < [details count]; i++) {
        TicketComment * comment = [details objectAtIndex:i];
        TicketDiff * diff =
            [[self class] parseYaml:comment.stateChangeDescription];
        TicketComment * commentWithDiffText =
            [[[TicketComment alloc]
            initWithStateChangeDescription:nil stateChange:diff
            text:comment.text date:comment.date]
            autorelease];
        id commentKey = [NSNumber numberWithInt:i];
        [commentCache setComment:commentWithDiffText forKey:commentKey];
        id authorKey = [authors objectAtIndex:i];
        [commentCache setAuthorKey:authorKey forCommentKey:commentKey];
    }

    [delegate receivedTicketDetailsFromDataSource:commentCache];
}

- (void)failedToFetchTicketDetailsForTicket:(id)ticketKey
    inProject:(id)projectKey errors:(NSArray *)errors
{
    [delegate failedToFetchTicketDetails:errors];
}

- (void)ticket:(id)ticketKey describedBy:(NewTicketDescription *)description
    createdForProject:(id)projectKey
{
    [delegate createdTicketWithKey:ticketKey];
}

- (void)failedToCreateNewTicketDescribedBy:(NewTicketDescription *)description
    forProject:(id)projectKey errors:(NSArray *)errors
{
    [delegate failedToCreateTicket:errors];
}

- (void)deletedTicket:(id)ticketKey forProject:(id)projectKey
{
    [delegate deletedTicketWithKey:ticketKey];
}

- (void)failedToDeleteTicket:(id)ticketKey forProject:(id)projectKey
    errors:(NSArray *)errors
{
    [delegate failedToDeleteTicket:ticketKey errors:errors];
}

- (void)editedTicket:(id)ticketNum forProject:(id)projectKey
    describedBy:(UpdateTicketDescription *)description
{
    LighthouseKey * ticketKey =
        [[[LighthouseKey alloc]
        initWithProjectKey:[projectKey intValue]
        key:[ticketNum intValue]]
        autorelease];
    [delegate editedTicketWithKey:ticketKey];
}

- (void)failedToEditTicket:(id)ticketKey forProject:(id)projectKey
    describedBy:(UpdateTicketDescription *)description errors:(NSArray *)errors
{
    [delegate failedToEditTicket:ticketKey errors:errors];
}

#pragma mark Accessors

- (void)setCredentials:(LighthouseCredentials *)someCredentials
{
    [service setCredentials:someCredentials];
}

#pragma mark Readable strings from yaml helpers

+ (TicketDiff *)parseYaml:(NSString *)yaml
{
    NSMutableDictionary * diff = [NSMutableDictionary dictionary];
    NSArray * lines = [yaml componentsSeparatedByString:@"\n"];

    for (NSString * line in lines) {
        NSArray * lineComps = [line componentsSeparatedByString:@":"];
        if ([lineComps count] > 1) {
            NSInteger count = [lineComps count];
            NSCharacterSet * charSet = [NSCharacterSet whitespaceCharacterSet];
            NSString * keyAsString =
                [[lineComps objectAtIndex:count - 2]
                stringByTrimmingCharactersInSet:charSet];
            NSInteger key =
                [TicketDiffHelpers ticketAttributeFromString:keyAsString];
            NSString * valueAsString =
                [[lineComps objectAtIndex:count - 1]
                stringByTrimmingCharactersInSet:charSet];

            id value;
            switch(key) {
                case kTicketAttributeAssignedTo:
                case kTicketAttributeMilestone:
                    value = [NSNumber numberWithInt:[valueAsString intValue]];
                    break;
                default:
                    value = valueAsString;
            }

            [diff setObject:value forKey:[NSNumber numberWithInt:key]];
        }
    }

    return diff;
}

@end
