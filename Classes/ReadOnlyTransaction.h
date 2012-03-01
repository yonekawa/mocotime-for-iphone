//
//  ReadOnlyTransaction.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/11.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"

// ReadOnlyTransaction
///
/// The class exists for readonly transaction.
/// It is the same as Transaction excluding not executing 'BEGIN'
/// at initWithDatabaseFilePath. 
//
@interface ReadOnlyTransaction : Transaction

@end
