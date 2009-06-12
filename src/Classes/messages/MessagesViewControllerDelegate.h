//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LighthouseKey.h"

@protocol MessagesViewControllerDelegate

- (void)selectedMessageKey:(LighthouseKey *)key;

@end
