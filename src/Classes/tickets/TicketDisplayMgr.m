//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "TicketDisplayMgr.h"
#import "NewTicketDescription.h"
#import "UpdateTicketDescription.h"
#import "LighthouseKey.h"
#import "TicketSearchMgr.h"
#import "UIAlertView+InstantiationAdditions.h"

@interface TicketDisplayMgr (Private)

- (void)addTicketOnServer:(EditTicketViewController *)sender;
- (void)initDarkTransparentView;
- (void)userDidSelectActiveProjectKey:(id)key;
- (void)prepareNewTicketView;
- (void)displayTicketDetails:(LighthouseKey *)key;
- (void)deleteTicketOnServer;
- (void)disableEditViewWithText:(NSString *)text;
- (void)enableEditView:(BOOL)dismiss;
- (void)updateDisplayIfDirty;
- (void)updateTicketsViewController;
- (void)correctSearchViewSize;
- (void)displayErrorWithTitle:(NSString *)title errors:(NSArray *)errors;

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
        displayDirty = YES;

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
    loadingLabel.text =
        NSLocalizedString(@"ticketdisplaymgr.creatingticket", @"");
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = [UIFont boldSystemFontOfSize:20];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.backgroundColor = [UIColor clearColor];
    [darkTransparentView addSubview:loadingLabel];
}

#pragma mark TicketsViewControllerDelegate implementation

- (void)selectedTicketKey:(LighthouseKey *)key
{
    NSLog(@"Ticket %@ selected", key);
    self.activeProjectKey = [NSNumber numberWithInt:key.projectKey];
    
    NSString * titleFormatString =
        NSLocalizedString(@"ticketdisplaymgr.title", @"");
    self.detailsNetAwareViewController.title =
        [NSString stringWithFormat:titleFormatString, key.key];
    [self.navController
        pushViewController:self.detailsNetAwareViewController animated:YES];

    TicketCommentCache * commentCache =
        [recentHistoryCommentCache objectForKey:key];
    if (commentCache)
        [self displayTicketDetails:key];

    [dataSource fetchTicketWithKey:key];
    self.detailsNetAwareViewController.cachedDataAvailable = !!commentCache;
    [self.detailsNetAwareViewController setUpdatingState:kConnectedAndUpdating];
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

- (void)resolveTicketWithKey:(LighthouseKey *)key
{
    UpdateTicketDescription * desc = [UpdateTicketDescription description];
    desc.state = kResolved;
    NSNumber * ticketKey =
        [NSNumber numberWithInteger:selectedTicketKey.key];
    [dataSource editTicketWithKey:ticketKey description:desc
        forProject:[NSNumber numberWithInt:selectedTicketKey.projectKey]];
}

- (void)displayTicketDetails:(LighthouseKey *)key
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
        if (!comment)
            [NSException raise:@"MissingTicketComment"
                format:@"Unable to find ticket comment for key %@",
                commentKey];
        [comments setObject:comment forKey:commentKey];
    }

    NSMutableDictionary * commentAuthors = [NSMutableDictionary dictionary];
    for (id commentKey in commentKeys) {
        NSString * userKey =
            [commentCache authorKeyForCommentKey:commentKey];
        NSString * commentAuthor = [userDict objectForKey:userKey];
        if (commentAuthor)
            [commentAuthors setObject:commentAuthor forKey:commentKey];
    }

    [self.detailsViewController setTicketNumber:key.key
        ticket:ticket metaData:metaData reportedBy:reportedBy
        assignedTo:assignedTo milestone:milestone comments:comments
        commentAuthors:commentAuthors];
}

- (void)ticketsFilteredByFilterString:(NSString *)aFilterString
{
    wrapperController.cachedDataAvailable = !!self.ticketCache;

    if (self.ticketCache)
        [self updateTicketsViewController];

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

- (void)updateTicketsViewController
{
    NSDictionary * allTickets = [ticketCache allTickets];
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

- (void)updateDisplayIfDirty
{
    if (displayDirty) {
        [self forceQueryRefresh];
        displayDirty = NO;
    }
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
    self.editTicketViewController.tags = metaData.tags;
    self.editTicketViewController.state = metaData.state;
    self.editTicketViewController.comment = @"";

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
    NSLog(@"Tickets view did appear.");

    // hack to account for odd behavior
    [self performSelector:@selector(correctSearchViewSize) withObject:nil
        afterDelay:0.5];

    [self updateDisplayIfDirty];
}

// hack to account for odd behavior
- (void)correctSearchViewSize
{
    UINavigationItem * navItem = self.wrapperController.navigationItem;
    UIView * searchView = navItem.titleView;
    CGRect searchViewFrame = searchView.frame;
    searchViewFrame.size.width = SEARCH_FIELD_WIDTH;
    searchView.frame = searchViewFrame;
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

- (void)failedToFetchTickets:(NSArray *)errors
{
    NSString * title =
        NSLocalizedString(@"ticketdisplaymgr.error.ticketsfetch.title", @"");

    [self displayErrorWithTitle:title errors:errors];
}

- (void)receivedTicketDetailsFromDataSource:(TicketCommentCache *)aCommentCache
{
    [recentHistoryCommentCache setObject:aCommentCache
        forKey:selectedTicketKey];
    [self displayTicketDetails:selectedTicketKey];
}

- (void)failedToFetchTicketDetails:(NSArray *)errors
{
    NSString * title =
        NSLocalizedString(@"ticketdisplaymgr.error.detailsfetch.title", @"");

    [self displayErrorWithTitle:title errors:errors];
}

- (void)createdTicketWithKey:(id)ticketKey
{
    [self enableEditView:YES];
    [self forceQueryRefresh];
}

- (void)failedToCreateTicket:(NSArray *)errors
{
    [self enableEditView:NO];

    NSString * title =
        NSLocalizedString(@"ticketdisplaymgr.error.create.title", @"");

    [self displayErrorWithTitle:title errors:errors];
}

- (void)editedTicketWithKey:(id)ticketKey
{
    NSLog(@"Edited ticket with key: %@", ticketKey);
    [self enableEditView:YES];
    [self forceQueryRefresh];
    if (self.wrapperController.navigationController.topViewController ==
        self.detailsNetAwareViewController) {

        [dataSource fetchTicketWithKey:ticketKey];
        [self.detailsNetAwareViewController
            setUpdatingState:kConnectedAndUpdating];
    }
}

- (void)failedToEditTicket:(id)ticketKey errors:(NSArray *)errors
{
    [self enableEditView:NO];
    [self updateTicketsViewController];

    NSString * title =
        NSLocalizedString(@"ticketdisplaymgr.error.edit.title", @"");

    [self displayErrorWithTitle:title errors:errors];
}

- (void)deletedTicketWithKey:(id)ticketKey
{
    [self.wrapperController.navigationController popViewControllerAnimated:NO];
    [self enableEditView:YES];
    [self forceQueryRefresh];
}

- (void)failedToDeleteTicket:(id)ticketKey errors:(NSArray *)errors
{
    [self enableEditView:NO];

    NSString * title =
        NSLocalizedString(@"ticketdisplaymgr.error.delete.title", @"");

    [self displayErrorWithTitle:title errors:errors];
}

- (void)enableEditView:(BOOL)dismiss
{
    [darkTransparentView removeFromSuperview];
    if (dismiss)
        [self.editTicketViewController dismissModalViewControllerAnimated:YES];
    self.editTicketViewController.cancelButton.enabled = YES;
    self.editTicketViewController.updateButton.enabled = YES;
}

- (void)displayErrorWithTitle:(NSString *)title errors:(NSArray *)errors
{
    NSLog(@"Failed to update tickets view: %@.", errors);

    NSError * firstError = [errors objectAtIndex:0];
    NSString * message =
        firstError ? firstError.localizedDescription : @"";

    UIAlertView * alertView =
        [UIAlertView simpleAlertViewWithTitle:title message:message];
    [alertView show];

    [wrapperController setUpdatingState:kDisconnected];
    [detailsNetAwareViewController setUpdatingState:kDisconnected];
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
        desc.state = sender.state;
        if (sender.member)
            desc.assignedUserKey = sender.member;
        if (sender.milestone)
            desc.milestoneKey = sender.milestone;
        desc.tags = sender.tags;

        NSNumber * ticketKey =
            [NSNumber numberWithInteger:selectedTicketKey.key];
        [dataSource editTicketWithKey:ticketKey description:desc
            forProject:[NSNumber numberWithInt:selectedTicketKey.projectKey]];
        actionText = NSLocalizedString(@"ticketdisplaymgr.editingticket", @"");
    } else {
        NewTicketDescription * desc = [NewTicketDescription description];
        desc.title = sender.ticketDescription;
        desc.body = sender.comment;
        desc.state = sender.state;
        if (sender.member)
            desc.assignedUserKey = sender.member;
        if (sender.milestone)
            desc.milestoneKey = sender.milestone;
        desc.tags = sender.tags;

        [dataSource createTicketWithDescription:desc
            forProject:activeProjectKey];
        actionText = NSLocalizedString(@"ticketdisplaymgr.creatingticket", @"");
    }
    
    [self disableEditViewWithText:actionText];
}

- (void)deleteTicketOnServer
{
    NSLog(@"Deleting ticket %@ on server...", selectedTicketKey);
    [self disableEditViewWithText:@"Deleting ticket..."];
    [dataSource deleteTicketWithKey:selectedTicketKey.key
        forProject:selectedTicketKey.projectKey];
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
    self.editTicketViewController.comment = @"";
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

#pragma mark API credential management

- (void)credentialsChanged:(LighthouseCredentials *)credentials
{
    [dataSource setCredentials:credentials];
    self.ticketCache = nil;
    [self.wrapperController.navigationController
        popToRootViewControllerAnimated:NO];
    [self ticketsFilteredByFilterString:@""];
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
        editButton.title =
            NSLocalizedString(@"ticketdisplaymgr.editbutton", @"");
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
    [self updateTicketsViewController];
}

- (void)setProjectDict:(NSDictionary *)aProjectDict
{
    NSDictionary * tempProjectDict = [aProjectDict copy];
    [projectDict release];
    projectDict = tempProjectDict;
    [self updateTicketsViewController];
}

- (void)setUserDict:(NSDictionary *)aUserDict
{
    NSDictionary * tempUserDict = [aUserDict copy];
    [userDict release];
    userDict = tempUserDict;
    [self updateTicketsViewController];
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
