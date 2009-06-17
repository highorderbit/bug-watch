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
#import "RecentHistoryCache.h"

@interface MessageDisplayMgr :
    NSObject
    <MessagesViewControllerDelegate, NetworkAwareViewControllerDelegate,
    MessageDataSourceDelegate, NewMessageViewControllerDelegate>
{
    MessageCache * messageCache;
    RecentHistoryCache * recentHistoryResponseCache;
    MessageDataSource * dataSource;
    NetworkAwareViewController * wrapperController;
    MessagesViewController * messagesViewController;

    NewMessageViewController * newMessageViewController;
    ProjectSelectionViewController * projectSelectionViewController;
    MessageDetailsViewController * detailsViewController;
    NetworkAwareViewController * detailsNetAwareViewController;

    NSDictionary * userDict;
    NSDictionary * projectDict;
    
    UIView * darkTransparentView;
    UILabel * loadingLabel;

    NSNumber * activeProjectKey;
    BOOL resetCache;
    BOOL selectProject;
    BOOL displayDirty;
}

@property (nonatomic, retain) MessageCache * messageCache;
@property (nonatomic, readonly)
    NewMessageViewController * newMessageViewController;
@property (nonatomic, readonly)
    ProjectSelectionViewController * projectSelectionViewController;
@property (nonatomic, readonly)
    MessageDetailsViewController * detailsViewController;
@property (readonly) NetworkAwareViewController * detailsNetAwareViewController;
@property (nonatomic, readonly) UINavigationController * navController;

@property (nonatomic, copy) NSDictionary * projectDict;
@property (nonatomic, copy) NSDictionary * userDict;

@property (nonatomic, copy) NSNumber * activeProjectKey;
@property (nonatomic, assign) BOOL selectProject;

@property (nonatomic, readonly) NetworkAwareViewController * wrapperController;

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    dataSource:(MessageDataSource *)aDataSource
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

- (void)createNewMessage;
- (void)credentialsChanged:(LighthouseCredentials *)credentials;

@end
