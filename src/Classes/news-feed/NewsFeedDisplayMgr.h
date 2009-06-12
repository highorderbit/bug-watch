//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedDataSourceDelegate.h"
#import "NewsFeedViewControllerDelegate.h"
#import "NetworkAwareViewControllerDelegate.h"

@class NewsFeedViewController, NewsFeedItemViewController;
@class NewsFeedDataSource;
@class NetworkAwareViewController;

@interface NewsFeedDisplayMgr :
    NSObject <NewsFeedViewControllerDelegate, NewsFeedDataSourceDelegate,
    NetworkAwareViewControllerDelegate>
{
    NetworkAwareViewController * networkAwareViewController;

    NewsFeedViewController * newsFeedViewController;
    NewsFeedItemViewController * newsFeedItemViewController;

    NewsFeedDataSource * newsFeedDataSource;
}

#pragma mark Initialization

- (id)initWithNetworkAwareViewController:(NetworkAwareViewController *)navc
                  newsFeedDataSource:(NewsFeedDataSource *)dataSource
                   leftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;

@end
