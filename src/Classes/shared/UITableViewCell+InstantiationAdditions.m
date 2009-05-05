//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "UITableViewCell+InstantiationAdditions.h"
#import "NSObject+RuntimeAdditions.h"

@implementation UITableViewCell (InstantiationAdditions)

+ (id)createCustomInstance
{
    return [[self class] createCustomInstanceWithNibName:[self className]];
}

+ (id)createCustomInstanceWithNibName:(NSString *)nibName
{
    NSArray * nib =
        [[NSBundle mainBundle]
          loadNibNamed:nibName
                 owner:self
               options:nil];

    return [nib objectAtIndex:0];
}

+ (NSString *)reuseIdentifier
{
    return [self className];
}

@end