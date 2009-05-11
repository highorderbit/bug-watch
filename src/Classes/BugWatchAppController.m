//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "BugWatchAppController.h"
#import "NetworkAwareViewController.h"
#import "TicketDetailsViewController.h"
#import "NewsFeedDisplayMgr.h"
#import "NewsFeedDataSource.h"
#import "NewsFeedViewController.h"
#import "LighthouseNewsFeedService.h"
#import "NetworkAwareViewController.h"
#import "TicketComment.h"
#import "MilestoneDisplayMgr.h"
#import "ProjectDisplayMgr.h"
#import "LighthouseApiService.h"
#import "MilestoneDataSource.h"
#import "MessageDisplayMgr.h"
#import "TicketsViewController.h"
#import "TicketDataSource.h"
#import "TicketSearchMgr.h"

@interface BugWatchAppController (Private)

- (void)initTicketsTab;
- (void)initProjectsTab;
- (void)initMessagesTab;

@end

@implementation BugWatchAppController

- (void)dealloc
{
    [newsFeedNetworkAwareViewController release];

    [ticketsNetAwareViewController release];
    [ticketsNavController release];

    [projectsViewController release];
    [projectsNavController release];

    [milestonesNetworkAwareViewController release];

    [messagesNetAwareViewController release];
    [messagesNavController release];

    [pagesViewController release];
    [pagesNavController release];

    [ticketCache release];
    [messageCache release];

    [newsFeedDisplayMgr release];
    [milestoneDisplayMgr release];

    [super dealloc];
}

- (void)start
{
    ticketCache = [[TicketCache alloc] init];
    messageCache = [[MessageCache alloc] init];

    // TEMPORARY: populate ticket cache
    NSString * description1 =
        @"If timing is just right, updating view can be added to wrong view controller when backing out of drill-down";
    NSString * message1 =
        @"The 'Next' button is enabled even when a username hasn't been supplied. Should it be? Is it important? The 'Done' button sends the request when both fields are blank and the second field is selected even though 'Add' is disabled.\n\nOne difference between the repo favorites add view and the log in view is that the log in view sends the request while the repo view just hides the keyboard in the above scenario. Not sure which is better or what the solution should be yet.";

    TicketComment * comment1 =
        [[[TicketComment alloc]
        initWithStateChangeDescription:@"State changed from 'new' to 'resolved'"
        text:@"Changed the log in view and the repo view to behave the same way: if valid input has not been provided, hitting the return key on the second text field does nothing."
        date:[NSDate date]] autorelease];
    TicketComment * comment2 =
        [[[TicketComment alloc]
        initWithStateChangeDescription:@"State changed from 'new' to 'hold'"
        text:@"blah blah blah" date:[NSDate date]] autorelease];
    [ticketCache setComment:comment1 forKey:[NSNumber numberWithInt:0]];
    [ticketCache setComment:comment2 forKey:[NSNumber numberWithInt:1]];

    NSMutableArray * comments = [NSMutableArray array];
    [comments addObject:[NSNumber numberWithInt:0]];
    [comments addObject:[NSNumber numberWithInt:1]];

    Ticket * ticket1 =
        [[[Ticket alloc] initWithDescription:description1 message:message1
        creationDate:[NSDate date]] autorelease];
    TicketMetaData * metaData1 =
        [[TicketMetaData alloc] initWithTags:@"bug ui" state:kNew
        lastModifiedDate:[NSDate date]];
        
    NSString * description2 = @"Really short description";
    Ticket * ticket2 =
        [[[Ticket alloc] initWithDescription:description2 message:@""
        creationDate:[NSDate date]] autorelease];
    TicketMetaData * metaData2 =
        [[TicketMetaData alloc] initWithTags:@"" state:kResolved
        lastModifiedDate:[NSDate date]];

    NSString * description3 = @"Support followed users in GitHub service";
    NSString * message3 = @"Steps to reproduce:\nFrom a user's page, tap one of their repositories that is not cached.\nQuickly return to the user page.\nTap a different repo.\nIt's possible that the first repo will load.";
    Ticket * ticket3 =
        [[[Ticket alloc] initWithDescription:description3 message:message3
        creationDate:[NSDate date]] autorelease];
    TicketMetaData * metaData3 =
        [[TicketMetaData alloc] initWithTags:@"bug" state:kHold
        lastModifiedDate:[NSDate date]];

    [ticketCache setTicket:ticket1 forNumber:213];
    [ticketCache setTicket:ticket2 forNumber:56];
    [ticketCache setTicket:ticket3 forNumber:217];
    
    [ticketCache setMetaData:metaData1 forNumber:213];
    [ticketCache setMetaData:metaData2 forNumber:56];
    [ticketCache setMetaData:metaData3 forNumber:217];
    
    [ticketCache setAssignedToKey:[NSNumber numberWithInt:0] forNumber:213];
    [ticketCache setAssignedToKey:[NSNumber numberWithInt:1] forNumber:56];
    [ticketCache setAssignedToKey:[NSNumber numberWithInt:0] forNumber:217];

    [ticketCache setCreatedByKey:[NSNumber numberWithInt:0] forNumber:213];
    [ticketCache setCreatedByKey:[NSNumber numberWithInt:0] forNumber:56];
    [ticketCache setCreatedByKey:[NSNumber numberWithInt:1] forNumber:217];

    [ticketCache setMilestoneKey:[NSNumber numberWithInt:0] forNumber:213];
    [ticketCache setMilestoneKey:[NSNumber numberWithInt:1] forNumber:56];
    [ticketCache setMilestoneKey:[NSNumber numberWithInt:1] forNumber:217];
    
    [ticketCache setCommentKeys:comments forNumber:213];
    [ticketCache setCommentKeys:[NSArray array] forNumber:56];
    [ticketCache setCommentKeys:[NSArray array] forNumber:217];
    
    [ticketCache setAuthorKey:[NSNumber numberWithInt:1]
        forCommentKey:[NSNumber numberWithInt:0]];
    [ticketCache setAuthorKey:[NSNumber numberWithInt:0]
        forCommentKey:[NSNumber numberWithInt:1]];
    // TEMPORARY
    
    // TEMPORARY: populate message cache
   Message * msg1 =
       [[Message alloc] initWithPostedDate:[NSDate date]
       title:@"App Store Description"
       message:@"Code Watch is the best way to get GitHub on your iPhone.\nKeep track of what's going on with all of your GitHub repositories, including your private ones."];
    Message * msg2 =
        [[Message alloc] initWithPostedDate:[NSDate date]
        title:@"What should we do with private information after logging out?"
        message:@"We don't really address this issue at all, currently. Off the top of my head, I suppose we should clear the primary user info (do we do that currently?), clear the news feed cache, and remove all repos in the repo cache marked as private. We could also just do the easy thing and clear all caches with potentially private information. Actually, I would probably favor the last solution. It's easy, and I don't think this use-case will be very common."];
    [messageCache setMessage:msg1 forKey:[NSNumber numberWithInt:0]];
    [messageCache setMessage:msg2 forKey:[NSNumber numberWithInt:1]];
    [messageCache setPostedByKey:[NSNumber numberWithInt:0]
        forKey:[NSNumber numberWithInt:1]];
    [messageCache setPostedByKey:[NSNumber numberWithInt:1]
        forKey:[NSNumber numberWithInt:0]];
    // TEMPORARY

    [self initTicketsTab];
    [self initProjectsTab];
    [self initMessagesTab];

    // Note: this instantiation/initialization is temporary
    LighthouseNewsFeedService * newsFeedService =
        [[[LighthouseNewsFeedService alloc] initWithBaseUrlString:
        @"http://highorderbit.lighthouseapp.com/events.atom"] autorelease];
    NewsFeedDataSource * newsFeedDataSource =
        [[[NewsFeedDataSource alloc]
        initWithNewsFeedService:newsFeedService] autorelease];

    newsFeedDisplayMgr =
        [[NewsFeedDisplayMgr alloc]
        initWithNetworkAwareViewController:newsFeedNetworkAwareViewController
                        newsFeedDataSource:newsFeedDataSource];

    LighthouseApiService * service =
        [[[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"]
        autorelease];
    MilestoneDataSource * milestoneDataSource =
        [[[MilestoneDataSource alloc]
        initWithLighthouseApiService:service] autorelease];
    milestoneDisplayMgr =
        [[MilestoneDisplayMgr alloc]
        initWithNetworkAwareViewController:
        milestonesNetworkAwareViewController
         milestoneDataSource:milestoneDataSource];
}

- (void)initTicketsTab
{
    UIBarButtonItem * cancelButton =
        ticketsNetAwareViewController.navigationItem.leftBarButtonItem;
    UIBarButtonItem * addButton =
        ticketsNetAwareViewController.navigationItem.rightBarButtonItem;
    UITextField * searchField =
        (UITextField *)ticketsNetAwareViewController.navigationItem.titleView;
    TicketSearchMgr * ticketSearchMgr =
        [[[TicketSearchMgr alloc]
        initWithSearchField:searchField addButton:addButton
        cancelButton:cancelButton
        navigationItem:ticketsNetAwareViewController.navigationItem]
        autorelease];
    
    TicketsViewController * ticketsViewController =
        [[[TicketsViewController alloc]
        initWithNibName:@"TicketsView" bundle:nil] autorelease];
    ticketsNetAwareViewController.targetViewController = ticketsViewController;
    
    LighthouseApiService * lighthouseApiService =
        [[[LighthouseApiService alloc]
        initWithBaseUrlString:@"https://highorderbit.lighthouseapp.com/"]
        autorelease];

    TicketDataSource * ticketDataSource =
        [[[TicketDataSource alloc] initWithService:lighthouseApiService]
        autorelease];
    lighthouseApiService.delegate = ticketDataSource;
    
    TicketDisplayMgr * ticketDisplayMgr =
        [[[TicketDisplayMgr alloc] initWithTicketCache:nil
        initialFilterString:nil navigationController:ticketsNavController
        networkAwareViewController:ticketsNetAwareViewController
        ticketsViewController:ticketsViewController
        dataSource:ticketDataSource] autorelease];
    ticketsViewController.delegate = ticketDisplayMgr;
    ticketsNetAwareViewController.delegate = ticketDisplayMgr;
    ticketDataSource.delegate = ticketDisplayMgr;
    ticketSearchMgr.delegate = ticketDisplayMgr;
    addButton.target = ticketDisplayMgr;
    addButton.action = @selector(addSelected);
}

- (void)initProjectsTab
{
    ProjectDisplayMgr * projectDisplayMgr =
        [[[ProjectDisplayMgr alloc] initWithProjectCache:nil
        navigationController:projectsNavController
        projectsViewController:projectsViewController] autorelease];
    projectsViewController.delegate = projectDisplayMgr;
}

- (void)initMessagesTab
{
    MessagesViewController * messagesViewController =
        [[MessagesViewController alloc]
        initWithNibName:@"MessagesView" bundle:nil];
    messagesNetAwareViewController.targetViewController =
        messagesViewController;

    MessageDisplayMgr * messageDisplayMgr =
        [[[MessageDisplayMgr alloc] initWithMessageCache:messageCache
        navigationController:messagesNavController
        networkAwareViewController:messagesNetAwareViewController
        messagesViewController:messagesViewController] autorelease];
    messagesViewController.delegate = messageDisplayMgr;
    messagesNetAwareViewController.delegate = messageDisplayMgr;
    
    UIBarButtonItem * addButton =
        messagesNetAwareViewController.navigationItem.rightBarButtonItem;
    addButton.target = messageDisplayMgr;
    addButton.action = @selector(createNewMessage);
}

@end
