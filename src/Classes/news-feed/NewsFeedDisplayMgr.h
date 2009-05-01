//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedDataSourceDelegate.h"
#import "NewsFeedViewControllerDelegate.h"

@class NewsFeedViewController, NewsFeedItemViewController;
@class NewsFeedDataSource;

@interface NewsFeedDisplayMgr :
    NSObject <NewsFeedViewControllerDelegate, NewsFeedDataSourceDelegate>
{
    NewsFeedViewController * newsFeedViewController;
    NewsFeedItemViewController * newsFeedItemViewController;

    NewsFeedDataSource * newsFeedDataSource;
}

#pragma mark Initialization

- (id)initWithNewsFeedViewController:(NewsFeedViewController *)controller
                  newsFeedDataSource:(NewsFeedDataSource *)dataSource;

@end
