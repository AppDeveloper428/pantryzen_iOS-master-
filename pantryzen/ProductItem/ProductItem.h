//
//  ProductItem.h
//  pantryzen
//
//  Created by admin on 19/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProductItem : NSObject
@property(readwrite) int                nPrice;
@property(readwrite) NSString           *strName;
@property(readwrite) int                nQty;
//@property(readwrite) UIViewController   *viewController;
//@property(readwrite) BOOL               bShouldLazyLoad;

@end
