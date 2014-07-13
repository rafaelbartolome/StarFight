//
//  STFViewController.m
//  StarFight
//
//  Created by Rafael Bartolome on 13/07/14.
//  Copyright (c) 2014 www.rafaelbartolome.es. All rights reserved.
//

#import "STFViewController.h"
#import "STFMarketVC.h"

@interface STFViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bkImageView;
@property (weak, nonatomic) IBOutlet UIButton *btMarket;

@end

@implementation STFViewController

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

    self.bkImageView.alpha = 0.0f;
    self.btMarket.alpha = 0.0f;
    self.btMarket.enabled = false;

    //Load initial logo
    UIImageView *logo = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"STFLogo"]];

    logo.frame = CGRectMake(self.view.center.x, self.view.center.y,
                            0, 0);
    logo.center = self.view.center;

    [self.view addSubview: logo];

    [UIView animateWithDuration: 1.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations: ^{
                        //Main Logo scale
                        logo.frame = CGRectMake(self.view.center.x - (400/2), self.view.center.y - (196/2),
                                                400, 196);
                        logo.center = self.view.center;
                     } completion:^(BOOL finished) {
                        //Main logo disolve and show background
                        [UIView animateWithDuration: 1.5
                                              delay: 0.0
                                            options: UIViewAnimationOptionCurveLinear
                                         animations: ^{
                                             //Main Logo scale
                                             logo.transform = CGAffineTransformMakeScale(3, 3);
                                             logo.alpha = 0.0f;
                                             self.bkImageView.alpha = 1.0f;

                                        } completion:^(BOOL finished) {
                                            [logo removeFromSuperview];
                                            [UIView animateWithDuration: .3
                                                             animations:^{
                                                                self.btMarket.alpha = 1.0f;
                                                            } completion:^(BOOL finished) {
                                                                self.btMarket.enabled = true;
                                                            }
                                             ];

                                        }
                         ];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)markedPressed:(id)sender {

    STFMarketVC *marketVC = [[STFMarketVC alloc] init];
    [self presentViewController: marketVC animated: YES completion:^{
        //Nothing to do here
    }];
}

@end
