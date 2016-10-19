//
//  EMABProductsTableViewController.m
//  Chapter12
//
//  Created by Liangjun Jiang on 4/19/15.
//  Copyright (c) 2015 Liangjun Jiang. All rights reserved.
//

#import "EMABProductsTableViewController.h"
#import "EMABConstants.h"
#import "EMABCategory.h"
#import "EMABProduct.h"
#import "EMABProductTableViewCell.h"
#import "EMABProductsFilterViewController.h"
#import "EMABProductDetailViewController.h"
@interface EMABProductsTableViewController()<UISearchBarDelegate>{
    float minPrice;
    float maxPrice;
}
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSString *keyword;
@end;

@implementation EMABProductsTableViewController


-(void)setBrand:(EMABCategory *)brand
{
    if (_brand != brand) {
        _brand = brand;
    }
}

-(void)updateUI {
    self.title = self.brand.title;
    [self.tableView reloadData];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.parseClassName = kProduct;
    self.objectsPerPage = 20;
    self.paginationEnabled = YES;
    self.pullToRefreshEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    minPrice = 0.0;
    maxPrice = 0.0;
    
    [self updateUI];
}


- (PFQuery *)queryForTable {
    [super queryForTable];
    PFQuery *query = [EMABProduct queryForCategory:self.brand];

    if (self.keyword) {
        query = [EMABProduct queryForCategory:self.brand keyword:self.keyword];
    }
    
    if (minPrice > 0 && maxPrice > 0) {
        query = [EMABProduct queryForCategory:self.brand minPrice:minPrice maxPrice:maxPrice];
    }
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    return query;
}

#pragma mark - IBAction
-(IBAction)onFilter:(id)sender
{
    EMABProductsFilterViewController *viewController = (EMABProductsFilterViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"EMABProductsFilterViewController"];
        
    __weak typeof(self) weakSelf = self;
    viewController.finishBlock = ^(EMABProductsFilterViewController *viewControlle, float minValue, float maxValue){
        minPrice = minValue;
        maxPrice = maxValue;
        weakSelf.keyword = nil;
        [weakSelf loadObjects];
    };
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Table View

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (EMABProductTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(EMABProduct *)object{
    EMABProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
   
    [cell configureItem:object];
   
    return cell;
}


#pragma mark - Table View Delegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowProductDetail"]) {
        EMABProductDetailViewController *viewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [viewController setProduct:self.objects[indexPath.row]];
    }
    
    
}

#pragma mark - searchbar delegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self clear];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] > 0) {
        [searchBar resignFirstResponder];
        self.keyword = searchBar.text;
        minPrice = 0.0;
        maxPrice = 0.0;
        [self loadObjects];
    }
}

#pragma  mark - scrollview Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
@end
