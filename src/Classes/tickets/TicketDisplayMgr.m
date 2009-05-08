//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDisplayMgr.h"

@implementation TicketDisplayMgr

- (void)dealloc
{
    [ticketCache release];
    [navController release];
    [ticketsViewController release];
    [detailsViewController release];
    [editTicketViewController release];

    // TEMPORARY
    [userDict release];
    [milestoneDict release];
    // TEMPORARY

    [super dealloc];
}

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    navigationController:(UINavigationController *)aNavController
    ticketsViewController:(TicketsViewController *)aTicketsViewController;
{
    if (self = [super init]) {
        ticketCache = [aTicketCache retain];
        navController = [aNavController retain];
        ticketsViewController = [aTicketsViewController retain];
        
        // TEMPORARY
        // this will eventually be read from a user cache of some sort
        userDict = [[NSMutableDictionary dictionary] retain];
        [userDict setObject:@"Doug Kurth" forKey:[NSNumber numberWithInt:0]];
        [userDict setObject:@"John A. Debay" forKey:[NSNumber numberWithInt:1]];

        // this will eventually be read from a user cache of some sort
        milestoneDict = [[NSMutableDictionary dictionary] retain];
        [milestoneDict setObject:@"1.1.0" forKey:[NSNumber numberWithInt:0]];
        [milestoneDict setObject:@"1.2.0" forKey:[NSNumber numberWithInt:1]];
        // TEMPORARY
    }

    return self;
}

#pragma mark TicketsViewControllerDelegate implementation

- (void)selectedTicketNumber:(NSUInteger)number
{
    NSLog(@"Ticket %d selected", number);
    selectedTicketNumber = number;

    [navController pushViewController:self.detailsViewController animated:YES];
    
    Ticket * ticket = [ticketCache ticketForNumber:number];
    TicketMetaData * metaData = [ticketCache metaDataForNumber:number];
    id reportedByKey = [ticketCache createdByKeyForNumber:number];
    NSString * reportedBy = [userDict objectForKey:reportedByKey];
    id assignedToKey = [ticketCache assignedToKeyForNumber:number];
    NSString * assignedTo = [userDict objectForKey:assignedToKey];
    id milestoneKey = [ticketCache milestoneKeyForNumber:number];
    NSString * milestone = [milestoneDict objectForKey:milestoneKey];
    
    NSArray * commentKeys = [ticketCache commentKeysForNumber:number];
    NSMutableDictionary * comments = [NSMutableDictionary dictionary];
    for (id commentKey in commentKeys) {
        TicketComment * comment = [ticketCache commentForKey:commentKey];
        [comments setObject:comment forKey:commentKey];
    }
    
    NSMutableDictionary * commentAuthors = [NSMutableDictionary dictionary];
    for (id commentKey in commentKeys) {
        NSString * userKey = [ticketCache authorKeyForCommentKey:commentKey];
        NSString * commentAuthor = [userDict objectForKey:userKey];
        [commentAuthors setObject:commentAuthor forKey:commentKey];
    }
    
    [self.detailsViewController setTicketNumber:number ticket:ticket
        metaData:metaData reportedBy:reportedBy assignedTo:assignedTo
        milestone:milestone comments:comments commentAuthors:commentAuthors];
}

- (void)ticketsFilteredByFilterKey:(NSString *)filterKey
{
    NSDictionary * allAssignedToKeys = [ticketCache allAssignedToKeys];
    NSMutableDictionary * assignedToDict = [NSMutableDictionary dictionary];
    for (NSNumber * ticketNumber in [allAssignedToKeys allKeys]) {
        id userKey = [allAssignedToKeys objectForKey:ticketNumber];
        [assignedToDict setObject:[userDict objectForKey:userKey]
            forKey:ticketNumber];
    }

    NSDictionary * allMilestoneKeys = [ticketCache allMilestoneKeys];
    NSMutableDictionary * associatedMilestoneDict =
        [NSMutableDictionary dictionary];
    for (NSNumber * ticketNumber in [allMilestoneKeys allKeys]) {
        id userKey = [allMilestoneKeys objectForKey:ticketNumber];
        [associatedMilestoneDict setObject:[milestoneDict objectForKey:userKey]
            forKey:ticketNumber];
    }

    [ticketsViewController setTickets:[ticketCache allTickets]
        metaData:[ticketCache allMetaData] assignedToDict:assignedToDict
        milestoneDict:associatedMilestoneDict];
}

#pragma mark TicketDetailsViewControllerDelegate implementation

- (void)editTicket
{
    Ticket * ticket = [ticketCache ticketForNumber:selectedTicketNumber];
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

@end
