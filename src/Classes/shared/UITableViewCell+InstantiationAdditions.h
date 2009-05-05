//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell (InstantiationAdditions)

+ (id)createCustomInstance;
+ (id)createCustomInstanceWithNibName:(NSString *)nibName;

+ (NSString *)reuseIdentifier;

@end