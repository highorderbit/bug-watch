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

@interface MessageDisplayMgr :
    NSObject
    <MessagesViewControllerDelegate, NetworkAwareViewControllerDelegate>
{
    MessageCache * messageCache;
    NetworkAwareViewController * wrapperController;
    MessagesViewController * messagesViewController;
    
    NewMessageViewController * newMessageViewController;
    MessageDetailsViewController * detailsViewController;

    // TEMPORARY
    NSMutableDictionary * userDict;
    // TEMPORARY
}

@property (nonatomic, readonly)
    NewMessageViewController * newMessageViewController;
@property (nonatomic, readonly)
    MessageDetailsViewController * detailsViewController;
@property (nonatomic, readonly) UINavigationController * navController;

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

- (void)createNewMessage;

@end
