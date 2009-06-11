//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDataSource.h"
#import "TicketCache.h"
#import "TicketCommentCache.h"
#import "TicketComment.h"
#import "NewTicketDescription.h"
#import "UpdateTicketDescription.h"

@interface TicketDataSource (Private)

+ (NSDictionary *)parseYaml:(NSString *)yaml;
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
    [token release];
    [super dealloc];
}

-(id)initWithService:(LighthouseApiService *)aService
{
    if (self = [super init]) {
        service = [aService retain];
        // TEMPORARY
        token = [@"6998f7ed27ced7a323b256d83bd7fec98167b1b3" retain];
    }

    return self;
}

- (void)fetchTicketsWithQuery:(NSString *)aFilterString page:(NSUInteger)page
{
    [service searchTicketsForAllProjects:aFilterString page:page token:token];
}

- (void)fetchTicketsWithQuery:(NSString *)aFilterString page:(NSUInteger)page
    project:(id)projectKey
{
    [service searchTicketsForProject:projectKey withSearchString:aFilterString
        page:page object:nil token:token];
}

- (void)fetchTicketWithKey:(TicketKey *)aTicketKey
{
    [service
        fetchDetailsForTicket:[NSNumber numberWithInt:aTicketKey.ticketNumber]
        inProject:aTicketKey.projectKey token:token];
}

- (void)createTicketWithDescription:(NewTicketDescription *)desc
    forProject:(id)projectKey
{
    [service createNewTicket:desc forProject:projectKey token:token];
}

- (void)editTicketWithKey:(id)key description:(UpdateTicketDescription *)desc
    forProject:(id)projectKey
{    
    [service editTicket:key forProject:projectKey withDescription:desc
        token:token];
}

- (void)deleteTicketWithKey:(id)key forProject:(id)projectKey
{
    [service deleteTicket:key forProject:projectKey token:token];
}

#pragma mark LighthouseApiServiceDelegate implementation

- (void)tickets:(NSArray *)tickets
    fetchedForSearchString:(NSString *)searchString page:(NSUInteger)page
    metadata:(NSArray *)someMetaData ticketNumbers:(NSArray *)ticketNumbers
    milestoneIds:(NSArray *)milestoneIds projectIds:(NSArray *)projectIds
    userIds:(NSArray *)userIds creatorIds:(NSArray *)creatorIds
{
    NSLog(@"Received tickets: %@", tickets);
    
    // create ticket cache
    TicketCache * ticketCache = [[TicketCache alloc] init];
    for (int i = 0; i < [ticketNumbers count]; i++) {
        NSNumber * number = [ticketNumbers objectAtIndex:i];
        NSUInteger numberAsInt = [((NSNumber *)number) intValue];
        id projectId = [projectIds objectAtIndex:i];
        id ticketKey =
            [[[TicketKey alloc]
            initWithProjectKey:projectId ticketNumber:numberAsInt] autorelease];

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
    page:(NSUInteger)page error:(NSError *)error
{}

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
    object:(id)object error:(NSError *)error
{}

- (void)details:(NSArray *)details authors:(NSArray *)authors
    fetchedForTicket:(id)ticketKey inProject:(id)projectKey
{
    NSLog(@"Received ticket details: %@", details);
    
    TicketCommentCache * commentCache =
        [[[TicketCommentCache alloc] init] autorelease];
    NSMutableArray * diffs = [NSMutableArray array];
    for (int i = 0; i < [details count]; i++) {
        TicketComment * comment = [details objectAtIndex:i];
        NSDictionary * diff =
            [[self class] parseYaml:comment.stateChangeDescription];
        [diffs addObject:diff];
    }

    for (int i = 0; i < [details count]; i++) {
        NSString * stateChangeDescription =
            [[self class] readableTextFromDiffs:diffs atIndex:i];
        TicketComment * comment = [details objectAtIndex:i];
        TicketComment * commentWithDiffText =
            [[[TicketComment alloc]
            initWithStateChangeDescription:stateChangeDescription
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
    inProject:(id)projectKey error:(NSError *)error
{}

- (void)ticket:(id)ticketKey describedBy:(NewTicketDescription *)description
    createdForProject:(id)projectKey
{
    [delegate createdTicketWithKey:ticketKey];
}

- (void)failedToCreateNewTicketDescribedBy:(NewTicketDescription *)description
    forProject:(id)projectKey error:(NSError *)error
{}

- (void)deletedTicket:(id)ticketKey forProject:(id)projectKey
{
    [delegate deletedTicketWithKey:ticketKey];
}

- (void)failedToDeleteTicket:(id)ticketKey forProject:(id)projectKey
    error:(NSError *)error
{}

#pragma mark Readable strings from yaml helpers

+ (NSDictionary *)parseYaml:(NSString *)yaml
{
    NSMutableDictionary * diff = [NSMutableDictionary dictionary];
    NSArray * lines = [yaml componentsSeparatedByString:@"\n"];

    for (NSString * line in lines) {
        NSArray * lineComps = [line componentsSeparatedByString:@":"];
        NSLog(@"Line: %@", line);
        if ([lineComps count] > 1) {
            NSInteger count = [lineComps count];
            NSCharacterSet * charSet = [NSCharacterSet whitespaceCharacterSet];
            NSString * key =
                [[lineComps objectAtIndex:count - 2]
                stringByTrimmingCharactersInSet:charSet];
            NSString * value =
                [[lineComps objectAtIndex:count - 1]
                stringByTrimmingCharactersInSet:charSet];
            value = [value isEqual:@""] ? @"none" : value;
            [diff setObject:value forKey:key];
        }
    }

    return diff;
}

+ (NSString *)readableTextFromDiffs:(NSArray *)diffs atIndex:(NSUInteger)index
{
    NSDictionary * diff = [diffs objectAtIndex:index];
    NSMutableString * text = [NSMutableString stringWithCapacity:0];

    for (NSString * key in [diff allKeys]) {
        NSString * value = [diff objectForKey:key];
        NSString * newValue =
            [[self class]
            findNextValueForKey:key inDiffs:diffs fromIndex:index + 1];
        [text appendFormat:@"→ %@ changed from '%@' to '%@'\n", key, value,
            newValue];
    }

    return text;
}

+ (NSString *)findNextValueForKey:(NSString *)key inDiffs:(NSArray *)diffs
    fromIndex:(NSUInteger)index
{
    NSString * nextValue = nil;

    for (int i = index; i < [diffs count] && !nextValue; i++) {
        NSDictionary * diff = [diffs objectAtIndex:i];
        nextValue = [diff objectForKey:key];
    }

    return nextValue ? nextValue : @"";
}

@end
