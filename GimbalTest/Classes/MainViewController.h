//
//  MainViewController.h
//  GimbalTest
//
//  Created by Rodrigo Borges Soares on 03/08/14.
//  Copyright (c) 2014 Ingresse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FYX/FYX.h>

#import <FYX/FYXVisitManager.h>

#import <FYX/FYXSightingManager.h>


@interface MainViewController : UIViewController<FYXServiceDelegate, FYXVisitDelegate>

@property (nonatomic) FYXVisitManager *visitManager;
@property (nonatomic) UILabel *rssiValueLabel;
@property (nonatomic) UILabel *temperatureLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UILabel *batteryLabel;




@end
