//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectSelectionViewController : UITableViewController
{
    NSDictionary * projects;

    id target;
    SEL action;
}

@property (nonatomic, retain) NSDictionary * projects;

@property (nonatomic, assign) id target;

// Takes method with signature like:
//    - (void)selectedProject:(id)projectKey;
@property(nonatomic) SEL action;

@end
