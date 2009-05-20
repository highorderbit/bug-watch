//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDisplayMgr.h"

@implementation TicketDisplayMgr

@synthesize ticketCache, commentCache, filterString;

- (void)dealloc
{
    [filterString release];
    [selectedTicketKey release];
    [ticketCache release];
    [commentCache release];

    [wrapperController release];
    [ticketsViewController release];
    [dataSource release];
    [detailsViewController release];
    [detailsNetAwareViewController release];
    [editTicketViewController release];

    // TEMPORARY
    [userDict release];
    [milestoneDict release];
    // TEMPORARY

    [super dealloc];
}

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    initialFilterString:(NSString *)initialFilterString
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    ticketsViewController:(TicketsViewController *)aTicketsViewController
    dataSource:(TicketDataSource *)aDataSource;
{
    if (self = [super init]) {
        self.filterString = initialFilterString;
        ticketCache = [aTicketCache retain];
        wrapperController = [aWrapperController retain];
        ticketsViewController = [aTicketsViewController retain];
        dataSource = [aDataSource retain];

        // TEMPORARY
        // this will eventually be read from a user cache of some sort
        userDict = [[NSMutableDictionary dictionary] retain];
        [userDict setObject:@"Doug Kurth"
            forKey:[NSNumber numberWithInt:50190]];
        [userDict setObject:@"John A. Debay"
            forKey:[NSNumber numberWithInt:50209]];

        // this will eventually be read from a user cache of some sort
        milestoneDict = [[NSMutableDictionary dictionary] retain];
        [milestoneDict setObject:@"1.0.0"
            forKey:[NSNumber numberWithInt:37670]];
        [milestoneDict setObject:@"1.1.0"
            forKey:[NSNumber numberWithInt:38299]];
        [milestoneDict setObject:@"1.3.0"
            forKey:[NSNumber numberWithInt:38302]];
        // TEMPORARY
    }

    return self;
}

#pragma mark TicketsViewControllerDelegate implementation

- (void)selectedTicketKey:(TicketKey *)key
{
    NSLog(@"Ticket %@ selected", key);

    if (self.navController.topViewController !=
        self.detailsNetAwareViewController) {

        self.detailsNetAwareViewController.title =
            [NSString stringWithFormat:@"Ticket %d", key.ticketNumber];
        [self.navController
            pushViewController:self.detailsNetAwareViewController animated:YES];
    }

    if (commentCache && [selectedTicketKey isEqual:key]) {
        [self.detailsNetAwareViewController
            setUpdatingState:kConnectedAndNotUpdating];        
        self.detailsNetAwareViewController.cachedDataAvailable = YES;
        
        Ticket * ticket = [self.ticketCache ticketForKey:key];
        TicketMetaData * metaData = [self.ticketCache metaDataForKey:key];
        id reportedByKey = [self.ticketCache createdByKeyForKey:key];
        NSString * reportedBy = [userDict objectForKey:reportedByKey];
        id assignedToKey = [self.ticketCache assignedToKeyForKey:key];
        NSString * assignedTo = [userDict objectForKey:assignedToKey];
        id milestoneKey = [self.ticketCache milestoneKeyForKey:key];
        NSString * milestone = [milestoneDict objectForKey:milestoneKey];

        NSArray * commentKeys = [ticketCache commentKeysForKey:key];
        NSMutableDictionary * comments = [NSMutableDictionary dictionary];
        for (id commentKey in commentKeys) {
            TicketComment * comment = [commentCache commentForKey:commentKey];
            [comments setObject:comment forKey:commentKey];
        }

        NSMutableDictionary * commentAuthors = [NSMutableDictionary dictionary];
        for (id commentKey in commentKeys) {
            NSString * userKey =
                [commentCache authorKeyForCommentKey:commentKey];
            NSString * commentAuthor = [userDict objectForKey:userKey];
            [commentAuthors setObject:commentAuthor forKey:commentKey];
        }

        [self.detailsViewController setTicketNumber:key.ticketNumber
            ticket:ticket metaData:metaData reportedBy:reportedBy
            assignedTo:assignedTo milestone:milestone comments:comments
            commentAuthors:commentAuthors];
    } else {
        [self.detailsNetAwareViewController
            setUpdatingState:kConnectedAndUpdating];        
        self.detailsNetAwareViewController.cachedDataAvailable = NO;
        [dataSource fetchTicketWithKey:key];
    }

    selectedTicketKey = key;
}

- (void)ticketsFilteredByFilterString:(NSString *)aFilterString
{
    NSDictionary * allTickets = [ticketCache allTickets];

    if (ticketCache &&
        (aFilterString == self.filterString ||
        [aFilterString isEqual:self.filterString])) {

        NSDictionary * allAssignedToKeys = [self.ticketCache allAssignedToKeys];

        [wrapperController setUpdatingState:kConnectedAndNotUpdating];        
        wrapperController.cachedDataAvailable = YES;
        
        NSMutableDictionary * assignedToDict = [NSMutableDictionary dictionary];
        for (NSNumber * ticketNumber in [allAssignedToKeys allKeys]) {
            id userKey = [allAssignedToKeys objectForKey:ticketNumber];
            id assignedTo = [userDict objectForKey:userKey];
            if (assignedTo)
                [assignedToDict setObject:assignedTo forKey:ticketNumber];
        }

        NSDictionary * allMilestoneKeys = [self.ticketCache allMilestoneKeys];
        NSMutableDictionary * associatedMilestoneDict =
            [NSMutableDictionary dictionary];
        for (NSNumber * ticketNumber in [allMilestoneKeys allKeys]) {
            id userKey = [allMilestoneKeys objectForKey:ticketNumber];
            id milestone = [milestoneDict objectForKey:userKey];
            if (milestone)
                [associatedMilestoneDict setObject:milestone
                    forKey:ticketNumber];
        }

        [ticketsViewController setTickets:allTickets
            metaData:[ticketCache allMetaData] assignedToDict:assignedToDict
            milestoneDict:associatedMilestoneDict];
    } else {
        [wrapperController setUpdatingState:kConnectedAndUpdating];
        wrapperController.cachedDataAvailable = NO;
        NSString * searchString = aFilterString ? aFilterString : @"";
        [dataSource fetchTicketsWithQuery:searchString];
    }

    self.filterString = aFilterString;
}

#pragma mark TicketDetailsViewControllerDelegate implementation

- (void)editTicket
{
    Ticket * ticket = [self.ticketCache ticketForKey:selectedTicketKey];
    TicketMetaData * metaData =
        [ticketCache metaDataForKey:selectedTicketKey];
    self.editTicketViewController.ticketDescription = ticket.description;
    self.editTicketViewController.message = ticket.message;
    self.editTicketViewController.tags = metaData.tags;
    self.editTicketViewController.state = metaData.state;

    self.editTicketViewController.member =
        [ticketCache assignedToKeyForKey:selectedTicketKey];
    self.editTicketViewController.members = [[userDict copy] autorelease];
    
    self.editTicketViewController.milestone =
        [ticketCache milestoneKeyForKey:selectedTicketKey];
    self.editTicketViewController.milestones =
        [[milestoneDict copy] autorelease];
    
    UINavigationController * tempNavController =
        [[[UINavigationController alloc]
        initWithRootViewController:self.editTicketViewController]
        autorelease];

    [self.detailsViewController presentModalViewController:tempNavController
        animated:YES];
        
    self.editTicketViewController.edit = YES;
}

#pragma mark NetworkAwareViewControllerDelegate

- (void)networkAwareViewWillAppear
{
    [self ticketsFilteredByFilterString:filterString];
}

#pragma mark TicketDataSourceDelegate implementation

- (void)receivedTicketsFromDataSource:(TicketCache *)aTicketCache
{
    self.ticketCache = aTicketCache;
    [self ticketsFilteredByFilterString:self.filterString];
}

- (void)receivedTicketDetailsFromDataSource:(TicketCommentCache *)aCommentCache
{
    self.commentCache = aCommentCache;
    [self selectedTicketKey:selectedTicketKey];
}

#pragma mark TicketDisplayMgr implementation

- (void)addSelected
{
    NSLog(@"Presenting 'add ticket' view");
    
    self.editTicketViewController.ticketDescription = @"";
    self.editTicketViewController.message = @"";
    self.editTicketViewController.tags = @"";
    self.editTicketViewController.state = kNew;

    self.editTicketViewController.member = nil;
    self.editTicketViewController.members = [[userDict copy] autorelease];
    
    self.editTicketViewController.milestone = nil;
    self.editTicketViewController.milestones =
        [[milestoneDict copy] autorelease];
        
    UINavigationController * tempNavController =
        [[[UINavigationController alloc]
        initWithRootViewController:self.editTicketViewController]
        autorelease];

    [self.navController presentModalViewController:tempNavController
        animated:YES];
        
    self.editTicketViewController.edit = NO;
}

#pragma mark Accessors

- (TicketDetailsViewController *)detailsViewController
{
    if (!detailsViewController) {
        TicketDetailsViewController * ticketDetailsViewController =
            [[TicketDetailsViewController alloc]
            initWithNibName:@"TicketDetailsView" bundle:nil];
        ticketDetailsViewController.delegate = self;

        detailsViewController = ticketDetailsViewController;
    }
        
    return detailsViewController;
}

- (NetworkAwareViewController *)detailsNetAwareViewController
{
    if (!detailsNetAwareViewController) {
        detailsNetAwareViewController =
            [[NetworkAwareViewController alloc]
            initWithTargetViewController:self.detailsViewController];
    }

    return detailsNetAwareViewController;
}

- (EditTicketViewController *)editTicketViewController
{
    if (!editTicketViewController)
        editTicketViewController =
            [[EditTicketViewController alloc]
            initWithNibName:@"EditTicketView" bundle:nil];

    return editTicketViewController;
}

- (UINavigationController *)navController
{
    return wrapperController.navigationController;
}

@end
