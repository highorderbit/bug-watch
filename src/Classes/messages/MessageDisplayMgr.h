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

@interface MessageDisplayMgr :
    NSObject
    <MessagesViewControllerDelegate, NetworkAwareViewControllerDelegate>
{
    MessageCache * messageCache;
    MessageResponseCache * responseCache;
    NetworkAwareViewController * wrapperController;
    MessagesViewController * messagesViewController;
    
    NewMessageViewController * newMessageViewController;
    MessageDetailsViewController * detailsViewController;

    // TEMPORARY
    NSMutableDictionary * userDict;
    NSMutableDictionary * projectDict;
    // TEMPORARY
}

@property (nonatomic, readonly)
    NewMessageViewController * newMessageViewController;
@property (nonatomic, readonly)
    MessageDetailsViewController * detailsViewController;
@property (nonatomic, readonly) UINavigationController * navController;

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    messageResponseCache:(MessageResponseCache *)aMessageResponseCache
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

- (void)createNewMessage;

@end
