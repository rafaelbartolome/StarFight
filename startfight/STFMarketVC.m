//
//  STFMarketVC.m
//  StarFight
//
//  Created by Rafael Bartolome on 13/07/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "STFMarketVC.h"
@import StoreKit;

@interface STFMarketVC () {

    //Transparent mask that apears during purchases
    UIView *_maskView;

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation STFMarketVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"marketCell" bundle:nil]
          forCellWithReuseIdentifier:@"marketCell"];


    [STFInAppController sharedInstance].delegate = self;

}

-(void)viewDidDisappear:(BOOL)animated {
    [STFInAppController sharedInstance].delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {

    [self dismissViewControllerAnimated: YES completion:^{
        //Nop
    }];

}
- (IBAction)restorePressed:(id)sender {

    //TODO
    /* Purchase restauration is not implemented in this demo*/

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not implemented"
                                                    message: @"No implemented yet"
                                                   delegate: nil
                                          cancelButtonTitle: @"cancel"
                                          otherButtonTitles: nil];
    [alert show];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[STFInAppController sharedInstance] countProducts];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"marketCell" forIndexPath:indexPath];

    UIImageView *imageView = (UIImageView*)[cell viewWithTag: 100];
    UILabel *name = (UILabel*)[cell viewWithTag: 200];
    UILabel *description = (UILabel*)[cell viewWithTag: 210];
    UILabel *price = (UILabel*)[cell viewWithTag: 300];

    //Step-3
    //{..}

    return cell;
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self loadMask];

    [[STFInAppController sharedInstance] buyProductForIndexPath: indexPath];

}

#pragma mark - STFInAppManagerDelegate

- (void) productPurchased:(NSDictionary*) product {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [product objectForKey:@"name"]
                                                    message: @"Purchase OK!"
                                                   delegate: nil
                                          cancelButtonTitle: @"Ok"
                                          otherButtonTitles: nil];
    [alert show];

    //TODO
    /* Purchase is not procesed in this demo.*/

    [self removeMask];
}



- (void) userCanceledTransaction {
    [self removeMask];
}


- (void) storeError: (NSString*) description title: (NSString*) title {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: description
                                                   delegate: nil
                                          cancelButtonTitle: @"Ok"
                                          otherButtonTitles: nil];
    [alert show];
    [self removeMask];

}

#pragma mark view mask

- (void) loadMask{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame: self.view.bounds];
        _maskView.userInteractionEnabled = YES;
        _maskView.backgroundColor = [UIColor whiteColor];

        UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        actInd.color = [UIColor blackColor];
        actInd.center = _maskView.center;
        [_maskView addSubview: actInd];
        [actInd startAnimating];

        [self.view addSubview: _maskView];
        _maskView.alpha = 0;
        [UIView animateWithDuration: .4 animations:^{
            _maskView.alpha = 0.5;
        }
         ];
    }
}

- (void) removeMask {
    if (_maskView) {
        [UIView animateWithDuration: .6
                         animations:^{
                             _maskView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [_maskView removeFromSuperview];
                             _maskView = nil;
                         }
         ];
    }
}


@end
