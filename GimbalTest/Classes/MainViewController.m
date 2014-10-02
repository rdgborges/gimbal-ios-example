//
//  MainViewController.m
//  GimbalTest
//
//  Created by Rodrigo Borges Soares on 03/08/14.
//  Copyright (c) 2014 Ingresse. All rights reserved.
//

#import "MainViewController.h"

#import <FYX/FYX.h>

#import <FYX/FYXSightingManager.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize visitManager;
@synthesize rssiValueLabel;
@synthesize temperatureLabel;
@synthesize subtitleLabel;
@synthesize nameLabel;
@synthesize batteryLabel;

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

    [self setContentView];

    [FYX startService:self];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject:[NSNumber numberWithInt:FYXSightingOptionSignalStrengthWindowLarge]
                forKey:FYXSightingOptionSignalStrengthWindowKey];
    
    self.visitManager = [FYXVisitManager new];
    self.visitManager.delegate = self;
    [self.visitManager start];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)serviceStarted
{
    // this will be invoked if the service has successfully started
    // bluetooth scanning will be started at this point.
    NSLog(@"FYX Service Successfully Started");
}

- (void)startServiceFailed:(NSError *)error
{
    // this will be called if the service has failed to start
    NSLog(@"%@", error);
}

- (void)setContentView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *demoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 300, 40)];
    [demoTitleLabel setBackgroundColor:[UIColor clearColor]];
    [demoTitleLabel setTextColor:[UIColor blackColor]];
    [demoTitleLabel setText:@"Qualcomm Gimbal DEMO"];
    demoTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [self.view addSubview:demoTitleLabel];
    
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 300, 40)];
    [subtitleLabel setBackgroundColor:[UIColor clearColor]];
    [subtitleLabel setTextColor:[UIColor blackColor]];
    [subtitleLabel setText:@"Nenhum beacon detectado!"];
    subtitleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.view addSubview:subtitleLabel];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 140, 200, 40)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor blackColor]];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.view addSubview:nameLabel];
    
    rssiValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 170, 200, 40)];
    [rssiValueLabel setBackgroundColor:[UIColor clearColor]];
    [rssiValueLabel setTextColor:[UIColor blackColor]];
    rssiValueLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.view addSubview:rssiValueLabel];
    
    temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 300, 40)];
    [temperatureLabel setBackgroundColor:[UIColor clearColor]];
    [temperatureLabel setTextColor:[UIColor blackColor]];
    temperatureLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.view addSubview:temperatureLabel];
    
    batteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 230, 300, 40)];
    [batteryLabel setBackgroundColor:[UIColor clearColor]];
    [batteryLabel setTextColor:[UIColor blackColor]];
    batteryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [self.view addSubview:batteryLabel];
    
}

/*
 * Visit Manager delegate
 */

- (void)didArrive:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter is sighted for the first time
    NSLog(@"I arrived at a Gimbal Beacon!!! %@", visit.transmitter.name);
    
    [subtitleLabel setText:@"Informações recebidas do Beacon:"];

    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                     message:@"Seja bem-vindo à nossa festa! Você acaba de ganhar um drink por conta da casa!"
                                                    delegate:self
                                           cancelButtonTitle:@"Woohoo!"
                                           otherButtonTitles: nil];

    [alert show];
    
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI;
{
    // this will be invoked when an authorized transmitter is sighted during an on-going visit
    NSLog(@"I received a sighting!!! %@\nRSSI: %f\nTemperature: %f)", visit.transmitter.name, [RSSI floatValue], ([visit.transmitter.temperature floatValue] -32)/1.8);
    
    float rssiValue = [RSSI floatValue];
    float temperatureValue = ([visit.transmitter.temperature floatValue]-32)/1.8;
    
    [nameLabel setText:[NSString stringWithFormat:@"Name: %@", visit.transmitter.name]];
    [rssiValueLabel setText:[NSString stringWithFormat:@"RSSI: %.2f", rssiValue]];
    [temperatureLabel setText:[NSString stringWithFormat:@"Temperature: %.2f °C", temperatureValue]];
    
    NSInteger batteryLife = [visit.transmitter.battery integerValue];
    
    if (batteryLife == 0) {
        [batteryLabel setText:[NSString stringWithFormat:@"Battery level: %ld (LOW)", (long) batteryLife]];
    }
    
    if (batteryLife == 1) {
        [batteryLabel setText:[NSString stringWithFormat:@"Battery level: %ld (MED/LOW)", (long) batteryLife]];
    }
    
    if (batteryLife == 2) {
        [batteryLabel setText:[NSString stringWithFormat:@"Battery level: %ld (MED/HIGH)", (long) batteryLife]];
    }
    
    if (batteryLife == 3) {
        [batteryLabel setText:[NSString stringWithFormat:@"Battery level: %ld (HIGH)", (long) batteryLife]];
    }
    
    
    
}
- (void)didDepart:(FYXVisit *)visit;
{
    // this will be invoked when an authorized transmitter has not been sighted for some time
    NSLog(@"I left the proximity of a Gimbal Beacon!!!! %@", visit.transmitter.name);
    NSLog(@"I was around the beacon for %f seconds", visit.dwellTime);
    
    [subtitleLabel setText:@"Saiu do alcance do sinal!"];
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@""
                                                     message:@"Foi ótimo contar com sua presença no nosso evento! Acesse nossas redes sociais para conferir fotos, vídeos e nos contar o que achou! :-)"
                                                    delegate:self
                                           cancelButtonTitle:@"Valeu!"
                                           otherButtonTitles: nil];
    
    [alert show];
}

@end
