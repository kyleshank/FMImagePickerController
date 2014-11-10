//
//  FMImagePickerController.m
//  Pods
//
//  Created by Kyle Shank on 7/5/14.
//
//

#import "FMImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FMImagePickerController ()

@property (nonatomic, retain) NSMutableArray *assetGroups;

@end

@implementation FMImagePickerController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        self.selectionMode=YES;
        self.ascending=NO;
        self.assetsFilter = [ALAssetsFilter allAssets];
        self.delegate=self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.assetGroups = [NSMutableArray array];
    self.library = [[ALAssetsLibrary alloc] init];
    [self loadGroups];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadGroups{
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
       {
           NSMutableArray* newGroups = [NSMutableArray array];
           
           // Group enumerator Block
           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
           {
               if((*stop) == YES){
                   return;
               }
               
               // Done
               if (group == nil) {
                   self.assetGroups = newGroups;
                   // Reload albums
                   ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:0];
                   [g setAssetsFilter:self.assetsFilter];
                   
                   self.assetGroup = g;
                   return;
               }
               
               // added fix for camera albums order
               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
               
               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                   [newGroups insertObject:group atIndex:0];
               }
               else {
                   [newGroups addObject:group];
               }
           };
           
           // Group Enumerator Failure Block
           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Photos access error" message:@"The app doesn't have permission to access your photos. Go to Settings > Privacy > Photos to grant access." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
               [alert show];
           };
           
           // Enumerate Albums
           [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:assetGroupEnumerator
                                     failureBlock:assetGroupEnumberatorFailure];
           
       });
}

- (void)preparePhotos
{
    if(self.assetGroup == nil){
        return;
    }
    NSMutableArray* newArray = [NSMutableArray array];
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if((*stop) == YES){
            return;
        }
        
        if(result == nil) {
            self.assets = newArray;
            return;
        }
        
        if(self.ascending){
            [newArray addObject:result];
        }else{
            [newArray insertObject:result atIndex:0];
        }
    }];
}

-(void)setAssetGroup:(ALAssetsGroup*)assetGroup{
    _assetGroup=assetGroup;
    self.assets = [NSMutableArray array];
    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    
    NSString* album = [self.assetGroup valueForProperty:ALAssetsGroupPropertyName];
    [self setTitle:album];
    
    if(self.navigationItem){
        UILabel* title = [[UILabel alloc] init];
        [title setText:[album stringByAppendingString:@" ▾"]];
        [title setFont:[UIFont boldSystemFontOfSize:18.0]];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setTextColor:[UINavigationBar appearance].tintColor];
        [title sizeToFit];
        title.userInteractionEnabled=YES;
        
        self.navigationItem.titleView=title;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTitleTapGesture:)];
        [self.navigationItem.titleView addGestureRecognizer:tapGesture];
    }
}

- (void)handleTitleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        if(self.assetGroups){
                UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
                [actionSheet setTitle:@"Albums"];
                [actionSheet setDelegate:self];
            
                for(int i =0; i < [self.assetGroups count]; i++){
                    ALAssetsGroup* g = [self.assetGroups objectAtIndex:i];
                    [actionSheet addButtonWithTitle:[g valueForProperty:ALAssetsGroupPropertyName]];
                }
                
                [actionSheet addButtonWithTitle:@"Cancel"];
                [actionSheet setCancelButtonIndex:[self.assetGroups count]];
                
                [actionSheet showInView:sender.view];
            }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]){
        [self setAssetGroup:[self.assetGroups objectAtIndex:buttonIndex]];
    }
}

-(void)assetTapped:(ALAsset*)asset atIndex:(NSUInteger)index{
    
}

-(void)assetLongPressed:(ALAsset*)asset atIndex:(NSUInteger)index{
    
}

@end
