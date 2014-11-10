//
//  FMAssetCollectionViewController.m
//  Pods
//
//  Created by Kyle Shank on 7/4/14.
//
//

#import "FMAssetCollectionViewController.h"
#import "FMAssetCollectionViewCell.h"

#define FM_COLLECTION_CELL_REUSE_ID @"FMCollectionViewCell"

@interface FMAssetCollectionViewController ()
@property (nonatomic, retain) NSMutableArray* selected;
@end

@implementation FMAssetCollectionViewController

-(id)init{
    if(self = [super init]){
        [self setDefaults];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setDefaults];
    }
    return self;
}

-(id)initWithAssets:(NSArray*)assets{
    if(self = [super init]){
        [self setDefaults];
        self.assets=assets;
    }
    return self;
}

-(void)setDefaults{
    self.assets = [NSArray array];
    self.selected = [NSMutableArray array];
    self.selectionMode = NO;
    self.cellSize = ([[UIScreen mainScreen] bounds].size.width-3.0) / 4.0;
    self.cellSpacing = 1.0;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        self.cellSize = ([[UIScreen mainScreen] bounds].size.width-5.0) / 6.0;
    }
}

-(void)loadView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing=self.cellSpacing;
    layout.minimumLineSpacing=self.cellSpacing;
    layout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView registerClass:[FMAssetCollectionViewCell class] forCellWithReuseIdentifier:FM_COLLECTION_CELL_REUSE_ID];
    self.view = self.collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Configuration

-(void)setAssets:(NSArray *)assets{
    _assets = assets;
    self.selected = [NSMutableArray array];
    if(self.collectionView){
        self.cellSize = (self.collectionView.frame.size.width-3.0) / 4.0;
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            self.cellSize = (self.collectionView.frame.size.width-5.0) / 6.0;
        }
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [self.collectionView setContentOffset:CGPointZero animated:NO];
            [self.collectionView reloadData];
        });
    }
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FMAssetCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:FM_COLLECTION_CELL_REUSE_ID forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.index = indexPath.row;
    cell.asset = [self.assets objectAtIndex:indexPath.row];
    cell.selected = [self assetSelected:cell.index];
    
    UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(assetLongPress:)];
    [cell addGestureRecognizer:pressRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetTap:)];
    [tapRecognizer requireGestureRecognizerToFail:pressRecognizer];
    [cell addGestureRecognizer:tapRecognizer];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.cellSize, self.cellSize);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.assets count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - Asset selection

- (void)assetTap:(UITapGestureRecognizer *)tapRecognizer
{
    NSInteger index = tapRecognizer.view.tag;
    if(self.selectionMode){
        BOOL isSelected = NO;
        for(int i = 0; i < [self.selected count]; i++){
            NSNumber* n = [self.selected objectAtIndex:i];
            if([n integerValue] == index){
                isSelected=YES;
                [self.selected removeObjectAtIndex:i];
                break;
            }
        }
        if(!isSelected){
            [self.selected addObject:[NSNumber numberWithInteger:index]];
        }
        [self.collectionView reloadData];
    }
    
    if(self.delegate!=nil){
        ALAsset* asset = [self.assets objectAtIndex:index];
        [self.delegate assetTapped:asset atIndex:index];
    }
}

- (void)assetLongPress:(UILongPressGestureRecognizer *)pressRecognizer
{
    if(pressRecognizer.state == UIGestureRecognizerStateBegan){
        NSInteger index = pressRecognizer.view.tag;
        if(self.delegate!=nil){
            ALAsset* asset = [self.assets objectAtIndex:index];
            [self.delegate assetLongPressed:asset atIndex:index];
        }
    }
}

- (BOOL) assetSelected:(NSUInteger)index{
    if(self.selectionMode){
        BOOL isSelected = NO;
        for(NSNumber* n in self.selected){
            if([n integerValue] == index){
                isSelected=YES;
                break;
            }
        }
        return isSelected;
    }else{
        return NO;
    }
}

-(NSArray*)selectedAssets{
    NSMutableArray* selection = [NSMutableArray array];
    for(int i = 0; i < [self.selected count]; i++){
        NSNumber* n = [self.selected objectAtIndex:i];
        ALAsset* asset = [self.assets objectAtIndex:[n integerValue]];
        [selection addObject:asset];
    }
    return selection;
}

-(void)deselectAll{
    [self.selected removeAllObjects];
    [self.collectionView reloadData];
}

-(void)selectAll{
    [self.selected removeAllObjects];
    for(int index = 0; index < [self.assets count]; index++){
        [self.selected addObject:[NSNumber numberWithInteger:index]];
    }
    [self.collectionView reloadData];
}

@end
