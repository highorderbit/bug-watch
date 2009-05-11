//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"
#import "MessagesViewController.h"
#import "NetworkAwareViewController.h"
#import "NetworkAwareViewControllerDelegate.h"
#import "NewMessageViewController.h"

@interface MessageDisplayMgr :
    NSObject
    <MessagesViewControllerDelegate, NetworkAwareViewControllerDelegate>
{
    MessageCache * messageCache;
    UINavigationController * navController;
    NetworkAwareViewController * wrapperController;
    MessagesViewController * messagesViewController;
    
    NewMessageViewController * newMessageViewController;
    // TEMPORARY
    NSMutableDictionary * userDict;
    // TEMPORARY
}

@property (nonatomic, readonly)
    NewMessageViewController * newMessageViewController;

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    navigationController:(UINavigationController *)aNavController
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

- (void)createNewMessage;

@end
