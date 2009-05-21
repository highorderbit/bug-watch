//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemSelectionTableViewController : UITableViewController
{
    NSDictionary * items;
    id selectedItem;
    NSString * labelText;

    id target;
    SEL action;
}

@property (nonatomic, copy) id selectedItem;
@property (nonatomic, assign) id target;

// Takes method with signature like:
//    - (void)setSelectedItem:(id)itemKey;
@property(nonatomic) SEL action;

- (void)setItems:(NSDictionary *)someItems;
- (void)setLabelText:(NSString *)text;

@end
