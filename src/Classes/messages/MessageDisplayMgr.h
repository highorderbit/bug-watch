//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageCache.h"
#import "MessagesViewController.h"

@interface MessageDisplayMgr : NSObject <MessagesViewControllerDelegate>
{
    MessageCache * messageCache;
    UINavigationController * navController;
    MessagesViewController * messagesViewController;
    
    // TEMPORARY
    NSMutableDictionary * userDict;
    // TEMPORARY
}

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    navigationController:(UINavigationController *)aNavController
    messagesViewController:(MessagesViewController *)aMessagesViewController;

@end
