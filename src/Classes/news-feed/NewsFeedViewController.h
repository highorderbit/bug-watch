//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedViewControllerDelegate.h"

@interface NewsFeedViewController : UITableViewController
{
    id<NewsFeedViewControllerDelegate> delegate;

    NSArray * newsItems;
}

@property (nonatomic, assign) id<NewsFeedViewControllerDelegate> delegate;

@end
