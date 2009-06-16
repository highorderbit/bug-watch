//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesViewControllerDelegate.h"

@interface MessagesViewController :
    UITableViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary * messages;
    NSDictionary * postedByDict;
    NSDictionary * projectDict;
    NSDictionary * numResponsesDict;
    NSObject<MessagesViewControllerDelegate> * delegate;

    NSArray * sortedKeyCache;
}

- (void)setMessages:(NSDictionary *)someMessages
    postedByDict:(NSDictionary *)aPostedByDict
    projectDict:(NSDictionary *)aProjectDict
    numResponsesDict:(NSDictionary *)aNumResponsesDict;

@property (nonatomic, assign)
    NSObject<MessagesViewControllerDelegate> * delegate;

@property (nonatomic, readonly) NSArray * sortedKeys;
@property (nonatomic, retain) NSArray * sortedKeyCache;

@end
