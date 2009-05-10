//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCommentViewController.h"
#import "ItemSelectionTableViewController.h"

@interface EditTicketViewController :
    UITableViewController <UITextFieldDelegate>
{
    IBOutlet UIView * headerView;
    IBOutlet UIBarButtonItem * cancelButton;
    IBOutlet UIBarButtonItem * updateButton;
    IBOutlet UITextField * descriptionTextField;
    IBOutlet UITextField * tagsTextField;

    AddCommentViewController * addCommentViewController;
    ItemSelectionTableViewController * itemSelectionTableViewController;

    NSString * ticketDescription;
    NSString * message;
    NSString * tags;

    NSDictionary * members;
    id member;

    NSDictionary * milestones;
    id milestone;

    NSUInteger state;

    NSArray * comments;
    
    BOOL edit;
}

@property (nonatomic, readonly)
    AddCommentViewController * addCommentViewController;
@property (nonatomic, readonly)
    ItemSelectionTableViewController * itemSelectionTableViewController;

@property (nonatomic, copy) NSString * ticketDescription;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * tags;

@property (nonatomic, copy) NSDictionary * members;
@property (nonatomic, copy) id member;

@property (nonatomic, copy) NSDictionary * milestones;
@property (nonatomic, copy) id milestone;

@property (nonatomic, assign) NSUInteger state;

@property (nonatomic, copy) NSArray * comments;

@property (nonatomic, assign) BOOL edit;

- (IBAction)cancel:(id)sender;
- (IBAction)update:(id)sender;

@end
