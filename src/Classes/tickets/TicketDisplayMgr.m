//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDisplayMgr.h"
#import "NewTicketDescription.h"
#import "UpdateTicketDescription.h"
#import "TicketKey.h"

@interface TicketDisplayMgr (Private)

- (void)addTicketOnServer:(EditTicketViewController *)sender;
- (void)initDarkTransparentView;
- (void)userDidSelectActiveProjectKey:(id)key;
- (void)prepareNewTicketView;
- (void)displayTicketDetails:(TicketKey *)key;
- (void)deleteTicketOnServer;
- (void)disableEditViewWithText:(NSString *)text;
- (void)enableEditView;

@property (nonatomic, readonly) NSDictionary * milestonesForProject;
@property (nonatomic, readonly) UIBarButtonItem * detailsEditButton;

@end

@implementation TicketDisplayMgr

@synthesize wrapperController, ticketsViewController, ticketCache,
    recentHistoryCommentCache, activeProjectKey, selectProject, milestoneDict,
    milestoneToProjectDict, projectDict, userDict;

- (void)dealloc
{
    [selectedTicketKey release];
    [ticketCache release];
    [recentHistoryCommentCache release];
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
    [milestoneToProjectDict release];
    [projectDict release];

    [darkTransparentView release];
    [loadingLabel release];

    [super dealloc];
}

- (id)initWithTicketCache:(TicketCache *)aTicketCache
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    ticketsViewController:(TicketsViewController *)aTicketsViewController
    dataSource:(TicketDataSource *)aDataSource;
{
    if (self = [super init]) {
        ticketCache = [aTicketCache retain];
        wrapperController = [aWrapperController retain];
        ticketsViewController = [aTicketsViewController retain];
        dataSource = [aDataSource retain];

        [self initDarkTransparentView];
        self.selectProject = YES;
        firstTimeDisplayed = YES;

        recentHistoryCommentCache =
            [[RecentHistoryCache alloc] initWithCacheLimit:20];
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
    loadingLabel = [[UILabel alloc] initWithFrame:loadingLabelFrame];
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

    TicketCommentCache * commentCache =
        [recentHistoryCommentCache objectForKey:key];
    if (commentCache)
        [self displayTicketDetails:key];

    [dataSource fetchTicketWithKey:key];
    self.detailsNetAwareViewController.cachedDataAvailable = !!commentCache;
    [self.detailsNetAwareViewController
        setUpdatingState:kConnectedAndUpdating];
    self.detailsEditButton.enabled = NO;

    selectedTicketKey = key;
}

- (void)loadMoreTickets
{
    NSUInteger pageToLoad = ticketCache.numPages + 1;
    NSLog(@"Loading more tickets (page %d)...", pageToLoad);
    [wrapperController setUpdatingState:kConnectedAndUpdating];
    wrapperController.cachedDataAvailable = YES;
    if (selectProject)
        [dataSource fetchTicketsWithQuery:self.ticketCache.query
            page:pageToLoad];
    else
        [dataSource fetchTicketsWithQuery:self.ticketCache.query
            page:pageToLoad project:activeProjectKey];
}

- (void)resolveTicketWithKey:(TicketKey *)key
{
    UpdateTicketDescription * desc = [UpdateTicketDescription description];
    desc.state = kResolved;
    NSNumber * ticketKey =
        [NSNumber numberWithInteger:selectedTicketKey.ticketNumber];
    [dataSource editTicketWithKey:ticketKey description:desc
        forProject:selectedTicketKey.projectKey];
}

- (void)displayTicketDetails:(TicketKey *)key
{
    self.detailsEditButton.enabled = YES;
            
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
    
    TicketCommentCache * commentCache =
        [recentHistoryCommentCache objectForKey:key];
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
    wrapperController.cachedDataAvailable = !!self.ticketCache;

    if (self.ticketCache) {
        NSDictionary * allAssignedToKeys = [self.ticketCache allAssignedToKeys];       

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
            milestoneDict:associatedMilestoneDict page:ticketCache.numPages];
    }

    if (![aFilterString isEqual:self.ticketCache.query]) {
        ticketCache.numPages = 1;
        [wrapperController setUpdatingState:kConnectedAndUpdating];
        NSString * searchString = aFilterString ? aFilterString : @"";
        if (selectProject)
            [dataSource fetchTicketsWithQuery:searchString page:1];
        else
            [dataSource fetchTicketsWithQuery:searchString page:1
                project:activeProjectKey];
    } else
        [wrapperController setUpdatingState:kConnectedAndNotUpdating];
}

- (void)forceQueryRefresh
{
    NSString * tempFilterString = self.ticketCache.query;
    self.ticketCache.query = nil;
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
    if (firstTimeDisplayed)
        [self forceQueryRefresh];
    else
        [self ticketsFilteredByFilterString:ticketCache.query];

    firstTimeDisplayed = NO;
}

#pragma mark TicketDataSourceDelegate implementation

- (void)receivedTicketsFromDataSource:(TicketCache *)aTicketCache
{
    NSLog(@"Received ticket cache: %@", aTicketCache);
    if (aTicketCache.numPages > 1) {
        [self.ticketCache merge:aTicketCache];
        if ([aTicketCache.allTickets count] == 0)
            [ticketsViewController setAllPagesLoaded:YES];
        else
            [ticketsViewController setAllPagesLoaded:NO];
    } else {
        self.ticketCache = aTicketCache;
        [ticketsViewController setAllPagesLoaded:NO];
    }

    [self ticketsFilteredByFilterString:self.ticketCache.query];
}

- (void)receivedTicketDetailsFromDataSource:(TicketCommentCache *)aCommentCache
{
    [recentHistoryCommentCache setObject:aCommentCache
        forKey:selectedTicketKey];
    [self displayTicketDetails:selectedTicketKey];
}

- (void)createdTicketWithKey:(id)ticketKey
{
    [self enableEditView];
    [self forceQueryRefresh];
}

- (void)deletedTicketWithKey:(id)ticketKey
{
    [self enableEditView];
    [self forceQueryRefresh];
}

- (void)enableEditView
{
    [darkTransparentView removeFromSuperview];
    [self.editTicketViewController dismissModalViewControllerAnimated:YES];
    self.editTicketViewController.cancelButton.enabled = YES;
    self.editTicketViewController.updateButton.enabled = YES;
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
        self.editTicketViewController.edit = NO;
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
    
    NSString * actionText;
    if (self.editTicketViewController.edit) {
        UpdateTicketDescription * desc = [UpdateTicketDescription description];
        desc.title = sender.ticketDescription;
        desc.comment = sender.comment;
        if (sender.state != 0)
            desc.state = sender.state;
        if (sender.member &&
            ![sender.member isEqual:[NSNumber numberWithInt:0]])
                desc.assignedUserKey = sender.member;
        if (sender.milestone &&
            ![sender.milestone isEqual:[NSNumber numberWithInt:0]])
                desc.milestoneKey = sender.milestone;
        desc.tags = sender.tags;

        NSNumber * ticketKey =
            [NSNumber numberWithInteger:selectedTicketKey.ticketNumber];
        [dataSource editTicketWithKey:ticketKey description:desc
            forProject:selectedTicketKey.projectKey];
        actionText = @"Editing ticket...";
    } else {
        NewTicketDescription * desc = [NewTicketDescription description];
        desc.title = sender.ticketDescription;
        desc.body = sender.message;
        if (sender.state != 0)
            desc.state = sender.state;
        if (sender.member &&
            ![sender.member isEqual:[NSNumber numberWithInt:0]])
                desc.assignedUserKey = sender.member;
        if (sender.milestone &&
            ![sender.milestone isEqual:[NSNumber numberWithInt:0]])
                desc.milestoneKey = sender.milestone;
        desc.tags = sender.tags;

        [dataSource createTicketWithDescription:desc
            forProject:activeProjectKey];
        actionText = @"Creating ticket...";
    }
    
    [self disableEditViewWithText:actionText];
}

- (void)deleteTicketOnServer
{
    NSLog(@"Deleting ticket %@ on server...");
    [self disableEditViewWithText:@"Deleting ticket..."];
    [dataSource deleteTicketWithKey:selectedTicketKey
        forProject:activeProjectKey];
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
}

- (void)disableEditViewWithText:(NSString *)text
{
    loadingLabel.text = text;
    [self.editTicketViewController.view.superview
        addSubview:darkTransparentView];
    self.editTicketViewController.cancelButton.enabled = NO;
    self.editTicketViewController.updateButton.enabled = NO;
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

- (UIBarButtonItem *)detailsEditButton
{
    return self.detailsNetAwareViewController.navigationItem.rightBarButtonItem;
}

- (EditTicketViewController *)editTicketViewController
{
    if (!editTicketViewController) {
        editTicketViewController =
            [[EditTicketViewController alloc]
            initWithNibName:@"EditTicketView" bundle:nil];
        editTicketViewController.target = self;
        self.editTicketViewController.action = @selector(addTicketOnServer:);
        self.editTicketViewController.deleteTicketAction =
            @selector(deleteTicketOnServer);
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
    
    [self ticketsFilteredByFilterString:ticketCache.query];
}

- (void)setProjectDict:(NSDictionary *)aProjectDict
{
    NSDictionary * tempProjectDict = [aProjectDict copy];
    [projectDict release];
    projectDict = tempProjectDict;
    
    [self ticketsFilteredByFilterString:ticketCache.query];
}

- (void)setUserDict:(NSDictionary *)aUserDict
{
    NSDictionary * tempUserDict = [aUserDict copy];
    [userDict release];
    userDict = tempUserDict;

    [self ticketsFilteredByFilterString:ticketCache.query];
}

- (NSDictionary *)milestonesForProject
{
    NSMutableDictionary * milestonesForProject =
        [NSMutableDictionary dictionary];

    for (id key in [milestoneToProjectDict allKeys]) {
        id projectKey = [milestoneToProjectDict objectForKey:key];
        if ([projectKey isEqual:activeProjectKey]) {
            NSString * milestoneName = [milestoneDict objectForKey:key];
            [milestonesForProject setObject:milestoneName forKey:key];
        }
    }

    return milestonesForProject;
}

@end
