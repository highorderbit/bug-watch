//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewMessageViewControllerDelegate

- (void)postNewMessage:(NSString *)message withTitle:(NSString *)title;

@end
