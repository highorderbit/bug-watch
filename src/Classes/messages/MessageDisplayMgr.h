//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"
#import "MessagesViewController.h"
#import "NetworkAwareViewController.h"
#import "NetworkAwareViewControllerDelegate.h"

@interface MessageDisplayMgr :
    NSObject
    <MessagesViewControllerDelegate, NetworkAwareViewControllerDelegate>
{
    MessageCache * messageCache;
    UINavigationController * navController;
    NetworkAwareViewController * wrapperController;
    MessagesViewController * messagesViewController;
    
    // TEMPORARY
    NSMutableDictionary * userDict;
    // TEMPORARY
}

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    navigationController:(UINavigationController *)aNavController
    networkAwareViewController:(NetworkAwareViewController *)aWrapperController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

- (void)createNewMessage;

@end
