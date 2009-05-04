//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemSelectionTableViewController : UITableViewController
{
    NSDictionary * items;
    id selectedItem;
    NSString * labelText;
}

@property (nonatomic, copy) id selectedItem;

- (void)setItems:(NSDictionary *)someItems;
- (void)setLabelText:(NSString *)text;

@end
