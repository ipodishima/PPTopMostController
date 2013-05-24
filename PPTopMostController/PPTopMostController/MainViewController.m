//
//  MainViewController.m
//  PPTopMostController
//
//  Created by Marian Paul on 24/05/13.
//  Copyright (c) 2013 iPuP. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    BOOL _isModal;
}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil isModal:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isModal:(BOOL)isModal {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isModal = isModal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isModal) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    }
    
    if (self.revealSideViewController) {
        UIViewController *rightController = [UIViewController new];
        [self.revealSideViewController preloadViewController:rightController forSide:PPRevealSideDirectionRight];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStyleBordered target:self action:@selector(showRight)];
    }
}

- (void)dismiss {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) showRight
{
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionRight animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)randomText {
    int random = arc4random() % 5;
    switch (random) {
        case 0:
            return @"Showing notification is great";
            break;
        case 1:
            return @"PPTopMostControllerProcol is awesome";
            break;
        case 2:
            return @"Imagine controls with this protocol";
            break;
        case 3:
            return @"You could have a shared notification view";
            break;
        case 4:
            return @"Visit RZNotificationView";
            break;
        default:
            break;
    }
    return @"This is a default message";
}

- (IBAction)showNotificationView:(id)sender {
    (void)[NotificationView showWithText:[self randomText]
                                   color:[UIColor colorWithRed:0.649 green:0.000 blue:0.000 alpha:1.000]
                       andHideAfterDelay:3.0];
}

- (IBAction)presentModalAction:(id)sender {
    MainViewController *m = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil isModal:YES];
    UINavigationController *n = [[UINavigationController alloc] initWithRootViewController:m];
    [self presentModalViewController:n animated:YES];
}

- (IBAction)pushViewAction:(id)sender {
    MainViewController *m = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil isModal:_isModal];
    [self.navigationController pushViewController:m animated:YES];
}

@end
