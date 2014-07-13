//
//  STFInAppController.m
//  StarFight
//
//  Created by Rafael Bartolome on 13/07/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "STFInAppController.h"

@interface STFInAppController () {

    NSMutableArray *_products;
    NSMutableArray *_transactionQueue;
    
}

@end

@implementation STFInAppController


+ (instancetype)sharedInstance {
    static STFInAppController *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _sharedInstance = [[self alloc]init];

    });

    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {

        //Step-1
        /* _products = [[NSMutableArray alloc] initWithArray: @[
                     @{@"id" : @"lightsaber",
                       @"image" : @"lightsaber",
                       @"name" : @"Lightsaber",
                       @"description" : @"The lightsaber is the weapon of a Jedi, an elegant weapon of a more civilized age. It can be used to cut through blast doors or enemies alike. Using the Force, a Jedi can predict and deflect incoming blaster bolts, and reflect them.",
                       @"price" : @"--",
                       @"product" : [NSNull null]

                       },
                     @{@"id" : @"blasterpistol",
                       @"image" : @"blaster",
                       @"name" : @"Blaster Pistol",
                       @"description" : @"The standard ranged weapon of both military personnel and civilians in the galaxy, the blaster pistol fires cohesive bursts of light-based energy called bolts.",
                       @"price" : @"--",
                       @"product" : [NSNull null]
                       },
                     @{@"id" : @"forcepush",
                       @"image" : @"push",
                       @"name" : @"Force Push",
                       @"description" : @"Force ability employed by Sith but more commonly by Jedi, allowing the wielder to shove people or objects from a distance.",
                       @"price" : @"--",
                       @"product" : [NSNull null]
                       },
                     @{@"id" : @"forcechoke",
                       @"image" : @"choke",
                       @"name" : @"Force Choke",
                       @"description" : @"Dark side power in which a Sith crushes a victim’s throat through the Force, often performed with a grip-like gesture.",
                       @"price" : @"--",
                       @"product" : [NSNull null]
                       }
                     ]];
        */

        NSMutableSet* identifierSet = [[NSMutableSet alloc] initWithCapacity: _products.count];


        for (NSDictionary *product in _products) {
            NSString *productID = [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle]  bundleIdentifier], [product objectForKey:@"id"]];
            [identifierSet addObject: productID];
        }

        //Step-2
        //{..}

    }
    return self;
}

- (void) registerAsTransactionObserver {


    if (!_transactionQueue) {
        _transactionQueue = [[NSMutableArray alloc] init];
    }

    //Step-5
    //{...}

}

- (int) countProducts{
    return (int)_products.count;
}

- (NSDictionary*) getProducDataForIndexPath: (NSIndexPath *)indexPath {

    NSInteger index = indexPath.row;

    if (index > self.countProducts) {
        return nil;
    }

    return [_products objectAtIndex: index];
}

- (void) buyProductForIndexPath: (NSIndexPath *)indexPath {

    NSDictionary *productDictionary = [self getProducDataForIndexPath: indexPath];

    if (productDictionary) {

        //Step-4
        //{..}

    } else {
        //Inform delegate that there was an error
        [self.delegate storeError: @"No product found!" title:@"In-App error"];
        return;
    }
}

//Step-2
//{..}

//Step-5
#pragma mark SKPaymentTransactionObserver

//{...}


- (void) completeTransaction: (SKPaymentTransaction *)transaction {

    //Step-7
    //{..}

    __weak __typeof(self)weakSelf = self;
    [self verifyReceipt: transaction
           onCompletion:^(bool validationResult, NSError *error) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (validationResult) {
                    //NSLog(@"  InApp.******   transaction verified ***********");

                    NSArray *productIDComponents = [transaction.payment.productIdentifier componentsSeparatedByString:@"."];
                    NSString *productID = [productIDComponents lastObject];
                    NSDictionary *productDictionary;
                    for (NSDictionary *productDic in _products) {
                        if ([[productDic objectForKey:@"id"] isEqualToString: productID]) {
                            productDictionary = productDic;
                            break;
                        }
                    }

                    if (productDictionary) {
                        [strongSelf.delegate productPurchased: productDictionary];
                    }

                } else {
                    if (!error) {
                        //NSLog(@"  InApp.******   transaction NOT verified ***********");
                        [strongSelf.delegate storeError: @"There was a problem downloading the content.\nPlease try again later."
                                                  title: @"Download error"];
                    } else {
                        //NSLog(@"  InApp.******   transaction verification ERROR ***********");
                        [strongSelf.delegate storeError: error.localizedFailureReason
                                                  title: error.localizedDescription ];
                    }
                }
            }
     ];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction {

    //TODO
    /* The functionality of restore transaction is not included inthis demo*/

    //Step-7
    //{..}

    //NSLog(@"  InApp.******   Purchase restored  ***********");
    [ self.delegate restoreComplete];

}

- (void) failedTransaction: (SKPaymentTransaction *)transaction {

    if (transaction.error.code != SKErrorPaymentCancelled)     {
        // Optionally, display an error here.
        NSLog(@"  InApp.failedTransaction: %@", transaction.error.localizedDescription );

        [self.delegate storeError: @"An Error Occurred.\nPlease try again later."
                            title: @"Ops!! An Error Occurred"];
    } else {
        //User canceled the purchase
        //NSLog(@"  InApp.failedTransaction:   user canceled purchase");
        [self.delegate userCanceledTransaction];
    }

    //Step-7
    //{..}

}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    //NSLog(@"User canceled restore");
    [self.delegate userCanceledTransaction];
}

- (void) verifyReceipt: (SKPaymentTransaction *) transaction onCompletion:(void(^)(bool validationResult, NSError *error)) completionBlock {

    //TODO
    /* Validation receipt not implemented in this demo */

    completionBlock( true, nil);

}


@end