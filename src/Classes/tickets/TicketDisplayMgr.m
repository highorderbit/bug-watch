//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDisplayMgr.h"

@implementation TicketDisplayMgr

@synthesize ticketCache, filterString;

- (void)dealloc
{
    [filterString release];
    [ticketCache release];
    [commentCache release];

    [wrapperController release];
    [ticketsViewController release];
    [dataSource release];
    [detailsViewController release];
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

- (void)selectedTicketNumber:(NSUInteger)number
{
    NSLog(@"Ticket %d selected", number);
    selectedTicketNumber = number;

    [self.navController pushViewController:self.detailsViewController
        animated:YES];
    
    Ticket * ticket = [self.ticketCache ticketForNumber:number];
    TicketMetaData * metaData = [self.ticketCache metaDataForNumber:number];
    id reportedByKey = [self.ticketCache createdByKeyForNumber:number];
    NSString * reportedBy = [userDict objectForKey:reportedByKey];
    id assignedToKey = [self.ticketCache assignedToKeyForNumber:number];
    NSString * assignedTo = [userDict objectForKey:assignedToKey];
    id milestoneKey = [self.ticketCache milestoneKeyForNumber:number];
    NSString * milestone = [milestoneDict objectForKey:milestoneKey];
    
    NSArray * commentKeys = [ticketCache commentKeysForNumber:number];
    NSMutableDictionary * comments = [NSMutableDictionary dictionary];
    for (id commentKey in commentKeys) {
        TicketComment * comment = [commentCache commentForKey:commentKey];
        [comments setObject:comment forKey:commentKey];
    }
    
    NSMutableDictionary * commentAuthors = [NSMutableDictionary dictionary];
    for (id commentKey in commentKeys) {
        NSString * userKey = [commentCache authorKeyForCommentKey:commentKey];
        NSString * commentAuthor = [userDict objectForKey:userKey];
        [commentAuthors setObject:commentAuthor forKey:commentKey];
    }
    
    [self.detailsViewController setTicketNumber:number ticket:ticket
        metaData:metaData reportedBy:reportedBy assignedTo:assignedTo
        milestone:milestone comments:comments commentAuthors:commentAuthors];
}

- (void)ticketsFilteredByFilterString:(NSString *)aFilterString
{
    NSDictionary * allTickets = [ticketCache allTickets];

    if (allTickets &&
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
    Ticket * ticket = [self.ticketCache ticketForNumber:selectedTicketNumber];
    TicketMetaData * metaData =
        [ticketCache metaDataForNumber:selectedTicketNumber];
    self.editTicketViewController.ticketDescription = ticket.description;
    self.editTicketViewController.message = ticket.message;
    self.editTicketViewController.tags = metaData.tags;
    self.editTicketViewController.state = metaData.state;

    self.editTicketViewController.member =
        [ticketCache assignedToKeyForNumber:selectedTicketNumber];
    self.editTicketViewController.members = [[userDict copy] autorelease];
    
    self.editTicketViewController.milestone =
        [ticketCache milestoneKeyForNumber:selectedTicketNumber];
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
    [self ticketsFilteredByFilterString:nil];
}

#pragma mark TicketDataSourceDelegate implementation

- (void)receivedTicketsFromDataSource:(TicketCache *)aTicketCache
{
    self.ticketCache = aTicketCache;
    [self ticketsFilteredByFilterString:self.filterString];
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
