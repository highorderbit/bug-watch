//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketBinDataSourceDelegate.h"

@protocol TicketBinDataSourceProtocol

@property (nonatomic, assign) NSObject<TicketBinDataSourceDelegate> * delegate;

@end
