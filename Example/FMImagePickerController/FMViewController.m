//
//  FMViewController.m
//  FMImagePickerController
//
//  Created by Kyle Shank on 07/04/2014.
//  Copyright (c) 2014 Kyle Shank. All rights reserved.
//

#import "FMViewController.h"
#import "FMSelectedViewController.h"

@interface FMViewController ()

@end

@implementation FMViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.selectionMode=YES;
        self.ascending=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)select:(id)sender{
    FMSelectedViewController* selectedVC = [[FMSelectedViewController alloc] init];
    selectedVC.assets = [self selectedAssets];
    [self.navigationController pushViewController:selectedVC animated:YES];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([[segue identifier] isEqualToString:@"Select"]){
         FMSelectedViewController* selectedVC = [segue destinationViewController];
         selectedVC.assets = [self selectedAssets];
     }
 }


@end
