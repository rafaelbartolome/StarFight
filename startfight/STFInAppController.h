//
//  STFInAppController.h
//  StarFight
//
//  Created by Rafael Bartolome on 13/07/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import <Foundation/Foundation.h>
@import StoreKit;

@protocol STFInAppManagerDelegate;

@interface STFInAppController : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

/**
 *  STFInAppManagerDelegate delegate in order to send messages about AppStore purchases
 */
@property (nonatomic) id <STFInAppManagerDelegate> delegate;


/**
 singleton pattern
 @return new STFInAppController object
 */
+ (instancetype)sharedInstance;


/**
 *  Register as a transaction observer of a payment queue
 */
- (void) registerAsTransactionObserver;


/**
 *  Returns number of products that can be purchased
 *  @return int with poduct count
 */
- (int) countProducts;


/**
 *  Return disctionary data for a product
 *  @param indexPath position of the product
 *  @return NSDictionary with product data
 */
- (NSDictionary*) getProducDataForIndexPath: (NSIndexPath *)indexPath;


/**
 *  Buy a product form appStore
 *  @param NSIndexPath for the product
 */
- (void) buyProductForIndexPath: (NSIndexPath *)indexPath;


@end


/**
 *  InAppManager delegate, send messages of the most important events with purchases
 */
@protocol STFInAppManagerDelegate <NSObject>

/**
 *  Informs delegat that purchase was OK
 *  @param NSDictionary product purchased
 */
- (void) productPurchased:(NSDictionary*) product;

/**
 *  Informs delegate that user canceled transaction
 */
- (void) userCanceledTransaction;

/**
 *  There was an error in the operation
 *  @param description NSString with localized description
 *  @param title       NSString with localized title
 */
- (void) storeError: (NSString*) description title: (NSString*) title;

@optional
/**
 *  Informs delagate that restore was OK
 */
- (void) restoreComplete;

@end