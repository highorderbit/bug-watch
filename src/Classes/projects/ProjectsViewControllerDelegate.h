//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProjectsViewControllerDelegate

- (void)selectedProjectKey:(id)key;
- (void)deselectedProject;

@end
