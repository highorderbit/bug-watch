//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import "MessageDisplayMgr.h"

@implementation MessageDisplayMgr

- (void)dealloc
{
    [messageCache release];
    [navController release];
    [messagesViewController release];
    
    // TEMPORARY
    [userDict release];
    // TEMPORARY
    
    [super dealloc];
}

- (id)initWithMessageCache:(MessageCache *)aMessageCache
    navigationController:(UINavigationController *)aNavController
    messagesViewController:(MessagesViewController *)aMessagesViewController
{
    if (self = [super init]) {
        messageCache = [aMessageCache retain];
        navController = [aNavController retain];
        messagesViewController = [aMessagesViewController retain];
        
        // TEMPORARY
        // this will eventually be read from a user cache of some sort
        userDict = [[NSMutableDictionary dictionary] retain];
        [userDict setObject:@"Doug Kurth" forKey:[NSNumber numberWithInt:0]];
        [userDict setObject:@"John A. Debay" forKey:[NSNumber numberWithInt:1]];
        // TEMPORARY
    }

    return self;
}

#pragma mark MessagesViewControllerDelegate implementation

- (void)showAllMessages
{
    NSMutableDictionary * postedByDict = [NSMutableDictionary dictionary];
    NSDictionary * allPostedByKeys = [messageCache allPostedByKeys];
    for (id key in allPostedByKeys) {
        id postedByKey = [allPostedByKeys objectForKey:key];
        NSString * postedByName = [userDict objectForKey:postedByKey];
        [postedByDict setObject:postedByName forKey:key];
    }
    
    NSMutableDictionary * projectDict = [NSMutableDictionary dictionary];
    NSLog(@"Posted by dict :%@", postedByDict);
    [messagesViewController setMessages:[messageCache allMessages]
        postedByDict:postedByDict projectDict:projectDict];
}

- (void)selectedMessageKey:(id)key
{}

@end
