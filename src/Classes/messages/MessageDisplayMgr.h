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

@interface MessageDisplayMgr :
    NSObject
    <MessagesViewControllerDelegate, NetworkAwareViewControllerDelegate,
    MessageDataSourceDelegate>
{
    MessageCache * messageCache;
    MessageResponseCache * responseCache;
    MessageDataSource * dataSource;
    NetworkAwareViewController * wrapperController;
    MessagesViewController * messagesViewController;

    NewMessageViewController * newMessageViewController;
    MessageDetailsViewController * detailsViewController;

    NSDictionary * userDict;
    NSDictionary * projectDict;

    id activeProjectKey;
    BOOL resetCache;
}

@property (nonatomic, retain) MessageCache * messageCache;
@property (nonatomic, readonly)
    NewMessageViewController * newMessageViewController;
@property (nonatomic, readonly)
    MessageDetailsViewController * detailsViewController;
@property (nonatomic, readonly) UINavigationController * navController;

@property (nonatomic, copy) NSDictionary * projectDict;
@property (nonatomic, copy) NSDictionary * userDict;

@property (nonatomic, copy) id activeProjectKey;

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    messageResponseCache:(MessageResponseCache *)aMessageResponseCache
    dataSource:(MessageDataSource *)aDataSource
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

- (void)createNewMessage;

@end
