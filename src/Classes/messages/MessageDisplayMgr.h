//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"
#import "MessagesViewController.h"
#import "NetworkAwareViewController.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "NewMessageViewController.h"
#import "MessageDetailsViewController.h"
#import "MessageResponseCache.h"
#import "MessageDataSource.h"
#import "MessageDataSourceDelegate.h"
#import "ProjectSelectionViewController.h"

@interface MessageDisplayMgr :
    NSObject
    <MessagesViewControllerDelegate, NetworkAwareViewControllerDelegate,
    MessageDataSourceDelegate, NewMessageViewControllerDelegate>
{
    MessageCache * messageCache;
    MessageResponseCache * responseCache;
    MessageDataSource * dataSource;
    NetworkAwareViewController * wrapperController;
    MessagesViewController * messagesViewController;

    NewMessageViewController * newMessageViewController;
    ProjectSelectionViewController * projectSelectionViewController;
    MessageDetailsViewController * detailsViewController;

    NSDictionary * userDict;
    NSDictionary * projectDict;
    
    UIView * darkTransparentView;
    UILabel * loadingLabel;

    id activeProjectKey;
    BOOL resetCache;
    BOOL selectProject;
}

@property (nonatomic, retain) MessageCache * messageCache;
@property (nonatomic, readonly)
    NewMessageViewController * newMessageViewController;
@property (nonatomic, readonly)
    ProjectSelectionViewController * projectSelectionViewController;
@property (nonatomic, readonly)
    MessageDetailsViewController * detailsViewController;
@property (nonatomic, readonly) UINavigationController * navController;

@property (nonatomic, copy) NSDictionary * projectDict;
@property (nonatomic, copy) NSDictionary * userDict;

@property (nonatomic, copy) id activeProjectKey;
@property (nonatomic, assign) BOOL selectProject;

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    messageResponseCache:(MessageResponseCache *)aMessageResponseCache
    dataSource:(MessageDataSource *)aDataSource
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

- (void)createNewMessage;

@end
