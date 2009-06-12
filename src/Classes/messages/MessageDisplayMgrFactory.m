//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDisplayMgrFactory.h"
#import "MessageDisplayProjectSetter.h"
#import "ProjectUpdatePublisher.h"
#import "UserSetAggregator.h"
#import "AllUserUpdatePublisher.h"
#import "MessageDisplayUserSetter.h"

@interface MessageDisplayMgrFactory (Private)

- (void)initProjectSetterForMessageDispMgr:(MessageDisplayMgr *)displayMgr;
- (void)initUserSetterForMessageDispMgr:(MessageDisplayMgr *)displayMgr;

@end

@implementation MessageDisplayMgrFactory

- (void)dealloc
{
    [apiToken release];
    [lighthouseApiFactory release];
    [super dealloc];
}

- (id)initWithApiToken:(NSString *)anApiToken
    lighthouseApiFactory:(LighthouseApiServiceFactory *)aLighthouseApiFactory
{
    if (self = [super init]) {
        apiToken = [anApiToken copy];
        lighthouseApiFactory = [aLighthouseApiFactory retain];
    }

    return self;
}

- (MessageDisplayMgr *)createMessageDisplayMgrWithCache:(MessageCache *)cache
    wrapperController:(NetworkAwareViewController *)wrapperController
{
    MessagesViewController * messagesViewController =
        [[MessagesViewController alloc]
        initWithNibName:@"MessagesView" bundle:nil];
    wrapperController.targetViewController = messagesViewController;

    LighthouseApiService * dataSourceService =
        [lighthouseApiFactory createLighthouseApiService];
    MessageDataSource * dataSource =
        [[[MessageDataSource alloc] initWithService:dataSourceService]
        autorelease];
    dataSource.token = apiToken;
    dataSourceService.delegate = dataSource;

    MessageDisplayMgr * messageDisplayMgr =
        [[[MessageDisplayMgr alloc] initWithMessageCache:cache
        dataSource:dataSource networkAwareViewController:wrapperController
        messagesViewController:messagesViewController] autorelease];
    messagesViewController.delegate = messageDisplayMgr;
    wrapperController.delegate = messageDisplayMgr;
    dataSource.delegate = messageDisplayMgr;

    [self initProjectSetterForMessageDispMgr:messageDisplayMgr];
    [self initUserSetterForMessageDispMgr:messageDisplayMgr];

    return messageDisplayMgr;
}

- (void)initProjectSetterForMessageDispMgr:(MessageDisplayMgr *)displayMgr
{
    // intentionally not autoreleasing either of the following objects
    MessageDisplayProjectSetter * projectSetter =
        [[MessageDisplayProjectSetter alloc]
        initWithMessageDisplayMgr:displayMgr];
    // just create, no need to assign a variable
    [[ProjectUpdatePublisher alloc]
        initWithListener:projectSetter
        action:@selector(fetchedAllProjects:projectKeys:)];
}

- (void)initUserSetterForMessageDispMgr:(MessageDisplayMgr *)displayMgr
{
    MessageDisplayUserSetter * userSetter =
        [[MessageDisplayUserSetter alloc]
        initWithMessageDisplayMgr:displayMgr];
    LighthouseApiService * userSetterService =
        [lighthouseApiFactory createLighthouseApiService];
    UserSetAggregator * userSetAggregator =
        [[UserSetAggregator alloc]
        initWithApiService:userSetterService token:apiToken];
    [[AllUserUpdatePublisher alloc]
        initWithListener:userSetter
        action:@selector(fetchedAllUsers:)];

    userSetterService.delegate = userSetAggregator;
    [[ProjectUpdatePublisher alloc]
        initWithListener:userSetAggregator
        action:@selector(fetchedAllProjects:projectKeys:)];
}

@end