//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectHomeViewController.h"

@protocol ProjectHomeViewControllerDelegate

- (void)selectedTab:(NSUInteger)tab;
- (void)deselectedTab;
- (void)deselectedProject;

@end
