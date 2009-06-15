//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIState : NSObject
{
    NSUInteger selectedTab;
    NSUInteger selectedProject;
    NSInteger selectedProjectTab;
}

@property (nonatomic) NSUInteger selectedTab;
@property (nonatomic) NSUInteger selectedProject;
@property (nonatomic) NSInteger selectedProjectTab;

@end
