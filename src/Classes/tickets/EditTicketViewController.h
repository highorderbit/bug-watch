//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddCommentViewController.h"
#import "ItemSelectionTableViewController.h"

@interface EditTicketViewController : UITableViewController
{
    IBOutlet UIBarButtonItem * cancelButton;
    IBOutlet UIBarButtonItem * updateButton;
    IBOutlet UITextField * descriptionTextField;
    IBOutlet UITextField * tagsTextField;

    AddCommentViewController * addCommentViewController;
    ItemSelectionTableViewController * itemSelectionTableViewController;

    NSString * ticketDescription;
    NSString * message;
    NSString * comment;
    NSString * tags;

    NSDictionary * members;
    id member;

    NSDictionary * milestones;
    id milestone;

    NSUInteger state;
    
    BOOL edit;
    
    id target;
    SEL action;
}

@property (nonatomic, readonly) UIBarButtonItem * cancelButton;
@property (nonatomic, readonly) UIBarButtonItem * updateButton;

@property (nonatomic, assign) id target;

// Takes method with signature like:
//    - (void)editTicket:(id)sender;
@property(nonatomic) SEL action;

@property (nonatomic, readonly)
    AddCommentViewController * addCommentViewController;
@property (nonatomic, readonly)
    ItemSelectionTableViewController * itemSelectionTableViewController;

@property (nonatomic, copy) NSString * ticketDescription;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic, copy) NSString * tags;

@property (nonatomic, copy) NSDictionary * members;
@property (nonatomic, copy) id member;

@property (nonatomic, copy) NSDictionary * milestones;
@property (nonatomic, copy) id milestone;

@property (nonatomic, assign) NSUInteger state;

@property (nonatomic, assign) BOOL edit;

- (IBAction)cancel:(id)sender;
- (IBAction)update:(id)sender;

@end
