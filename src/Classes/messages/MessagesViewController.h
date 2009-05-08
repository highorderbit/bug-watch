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
    
    NSObject<MessagesViewControllerDelegate> * delegate;
}

- (void)setMessages:(NSDictionary *)someMessages
    postedByDict:(NSDictionary *)postedByDict
    projectDict:(NSDictionary *)projectDict;

@property (nonatomic, retain)
    NSObject<MessagesViewControllerDelegate> * delegate;

@end
