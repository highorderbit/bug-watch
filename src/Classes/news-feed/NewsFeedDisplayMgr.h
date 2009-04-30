//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedViewControllerDelegate.h"

@class NewsFeedViewController, NewsFeedItemViewController;

@interface NewsFeedDisplayMgr : NSObject <NewsFeedViewControllerDelegate>
{
    UINavigationController * navigationController;

    NewsFeedItemViewController * newsFeedItemViewController;
}

#pragma mark Initialization

- (id)initWithNewsFeedViewController:(NewsFeedViewController *)controller;

@end
