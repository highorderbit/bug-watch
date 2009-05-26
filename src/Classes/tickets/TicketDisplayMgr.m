//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDisplayMgr.h"
#import "NewTicketDescription.h"

@interface TicketDisplayMgr (Private)

- (void)addTicketOnServer:(EditTicketViewController *)sender;
- (void)initDarkTransparentView;
- (void)userDidSelectActiveProjectKey:(id)key;
- (void)prepareNewTicketView;
- (void)displayTicketDetails:(TicketKey *)key;

@property (nonatomic, readonly) NSDictionary * milestonesForProject;

@end

@implementation TicketDisplayMgr

@synthesize ticketCache, commentCache, filterString, activeProjectKey,
    selectProject, milestoneDict, userDict;

- (void)dealloc
{
    [filterString release];
    [selectedTicketKey release];
    [ticketCache release];
    [commentCache release];
    [activeProjectKey release];

    [wrapperController release];
    [ticketsViewController release];
    [dataSource release];
    [detailsViewController release];
    [detailsNetAwareViewController release];
    [editTicketViewController release];
    [projectSelectionViewController release];

    [userDict release];
    [milestoneDict release];
    [projectDict release];

    [darkTransparentView release];

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

        [self initDarkTransparentView];
        self.selectProject = YES;

        // TEMPORARY
        self.activeProjectKey = [NSNumber numberWithInt:30772];

        // this will eventually be read from a user cache of some sort
        userDict = [[NSMutableDictionary dictionary] retain];
        [userDict setObject:@"Doug Kurth"
            forKey:[NSNumber numberWithInt:50190]];
        [userDict setObject:@"John A. Debay"
            forKey:[NSNumber numberWithInt:50209]];

        projectDict = [[NSMutableDictionary dictionary] retain];
        [projectDict setObject:@"Bug Watch"
            forKey:[NSNumber numberWithInt:30772]];
        [projectDict setObject:@"Code Watch"
            forKey:[NSNumber numberWithInt:27400]];
        // TEMPORARY
    }

    return self;
}

- (void)initDarkTransparentView
{
    CGRect darkTransparentViewFrame = CGRectMake(0, 0, 320, 480);
    darkTransparentView =
        [[UIView alloc] initWithFrame:darkTransparentViewFrame];
    
    CGRect transparentViewFrame = CGRectMake(0, 0, 320, 480);
    UIView * transparentView =
        [[[UIView alloc] initWithFrame:transparentViewFrame] autorelease];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha = 0.8;
    [darkTransparentView addSubview:transparentView];
    
    CGRect activityIndicatorFrame = CGRectMake(142, 85, 37, 37);
    UIActivityIndicatorView * activityIndicator =
        [[UIActivityIndicatorView alloc] initWithFrame:activityIndicatorFrame];
    activityIndicator.activityIndicatorViewStyle =
        UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicator startAnimating];
    [darkTransparentView addSubview:activityIndicator];
    
    CGRect loadingLabelFrame = CGRectMake(21, 120, 280, 65);
    UILabel * loadingLabel =
        [[[UILabel alloc] initWithFrame:loadingLabelFrame] autorelease];
    loadingLabel.text = @"Creating ticket...";
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:20];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [darkTransparentView addSubview:loadingLabel];
}

#pragma mark TicketsViewControllerDelegate implementation

- (void)selectedTicketKey:(TicketKey *)key
{
    NSLog(@"Ticket %@ selected", key);

    self.detailsNetAwareViewController.title =
        [NSString stringWithFormat:@"Ticket %d", key.ticketNumber];
    [self.navController
        pushViewController:self.detailsNetAwareViewController animated:YES];

    if (commentCache && [selectedTicketKey isEqual:key])
        [self displayTicketDetails:key];
    else {
        [dataSource fetchTicketWithKey:key];
        self.detailsNetAwareViewController.cachedDataAvailable = NO;
        [self.detailsNetAwareViewController
            setUpdatingState:kConnectedAndUpdating];
    }

    selectedTicketKey = key;
}

- (void)displayTicketDetails:(TicketKey *)key
{
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

    NSArray * commentKeys = [[commentCache allComments] allKeys];
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

- (void)forceQueryRefresh
{
    NSString * tempFilterString = self.filterString;
    self.filterString = nil;
    [self ticketsFilteredByFilterString:tempFilterString];
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
    self.editTicketViewController.milestones = self.milestonesForProject;
    
    UINavigationController * tempNavController =
        [[[UINavigationController alloc]
        initWithRootViewController:self.editTicketViewController]
        autorelease];

    [self.detailsNetAwareViewController
        presentModalViewController:tempNavController animated:YES];
        
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
    [self displayTicketDetails:selectedTicketKey];
}

- (void)createdTicketWithKey:(id)ticketKey
{
    [darkTransparentView removeFromSuperview];
    [self.editTicketViewController dismissModalViewControllerAnimated:YES];
    self.editTicketViewController.cancelButton.enabled = YES;
    self.editTicketViewController.updateButton.enabled = YES;
    [self forceQueryRefresh];
}

#pragma mark TicketDisplayMgr implementation

- (void)addSelected
{
    UIViewController * rootViewController;

    if (selectProject) {
        rootViewController = self.projectSelectionViewController;
        self.projectSelectionViewController.projects = projectDict;
    } else {
        [self prepareNewTicketView];
        rootViewController = self.editTicketViewController;
    }
    
    UINavigationController * tempNavController =
        [[[UINavigationController alloc]
        initWithRootViewController:rootViewController]
        autorelease];

    [self.navController presentModalViewController:tempNavController
        animated:YES];
}

- (void)addTicketOnServer:(EditTicketViewController *)sender
{
    NSLog(@"Sending new ticket definition to server...");

    NewTicketDescription * desc = [NewTicketDescription description];
    desc.title = sender.ticketDescription;
    desc.body = sender.message;
    if (sender.state != 0)
        desc.state = sender.state;
    if (sender.member && ![sender.member isEqual:[NSNumber numberWithInt:0]])
        desc.assignedUserKey = sender.member;
    if (sender.milestone &&
        ![sender.milestone isEqual:[NSNumber numberWithInt:0]])
            desc.milestoneKey = sender.milestone;
    desc.tags = sender.tags;

    [dataSource createTicketWithDescription:desc forProject:activeProjectKey];
    
    [self.editTicketViewController.view addSubview:darkTransparentView];
    self.editTicketViewController.cancelButton.enabled = NO;
    self.editTicketViewController.updateButton.enabled = NO;
}

- (void)userDidSelectActiveProjectKey:(id)key
{
    NSLog(@"User selected project %@ for ticket editing", key);
    self.activeProjectKey = key;
    [self prepareNewTicketView];
    [self.projectSelectionViewController.navigationController
        pushViewController:self.editTicketViewController animated:YES];
}

- (void)prepareNewTicketView
{
    self.editTicketViewController.ticketDescription = @"";
    self.editTicketViewController.message = @"";
    self.editTicketViewController.tags = @"";
    self.editTicketViewController.state = kNew;

    self.editTicketViewController.member = [NSNumber numberWithInt:0];
    self.editTicketViewController.members = [[userDict copy] autorelease];
    
    self.editTicketViewController.milestone = [NSNumber numberWithInt:0];
    self.editTicketViewController.milestones = self.milestonesForProject;

    self.editTicketViewController.edit = NO;
    self.editTicketViewController.action = @selector(addTicketOnServer:);
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
        UIBarButtonItem * editButton =
            [[[UIBarButtonItem alloc] init] autorelease];
        editButton.title = @"Edit";
        editButton.target = self;
        editButton.action = @selector(editTicket);
        [detailsNetAwareViewController.navigationItem
            setRightBarButtonItem:editButton animated:NO];
    }

    return detailsNetAwareViewController;
}

- (EditTicketViewController *)editTicketViewController
{
    if (!editTicketViewController) {
        editTicketViewController =
            [[EditTicketViewController alloc]
            initWithNibName:@"EditTicketView" bundle:nil];
        editTicketViewController.target = self;
    }

    return editTicketViewController;
}

- (ProjectSelectionViewController *)projectSelectionViewController
{
    if (!projectSelectionViewController) {
        projectSelectionViewController =
            [[ProjectSelectionViewController alloc]
            initWithNibName:@"ProjectSelectionView" bundle:nil];
        projectSelectionViewController.target = self;
        projectSelectionViewController.action =
            @selector(userDidSelectActiveProjectKey:);
    }

    return projectSelectionViewController;
}


- (UINavigationController *)navController
{
    return wrapperController.navigationController;
}

- (void)setMilestoneDict:(NSDictionary *)aMilestoneDict
{
    NSDictionary * tempMilestoneDict = [aMilestoneDict copy];
    [milestoneDict release];
    milestoneDict = tempMilestoneDict;
    
    [ticketsViewController.tableView reloadData];
}

- (NSDictionary *)milestonesForProject
{
    // TODO: implement
    return [[milestoneDict copy] autorelease];
}

@end
