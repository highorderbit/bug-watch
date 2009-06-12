//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LogInViewControllerDelegate

- (void)userDidProvideAccount:(NSString *)account
                     username:(NSString *)username
                     password:(NSString *)password;

- (void)userDidCancel;

@end
