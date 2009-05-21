//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTicketTableViewCell : UITableViewCell
{
    IBOutlet UILabel * keyLabel;
    IBOutlet UILabel * valueLabel;
    
    BOOL keyOnly;
}

@property (nonatomic, assign) BOOL keyOnly;

- (void)setKeyText:(NSString *)text;
- (void)setValueText:(NSString *)text;

+ (CGFloat)heightForContent:(NSString *)content;

@end
