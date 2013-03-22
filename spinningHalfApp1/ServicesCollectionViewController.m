//
//  ServicesCollectionViewController.m
//  spinningHalfApp1
//
//  Created by andre trosky on 13/03/13.
//  Copyright (c) 2013 andre trosky. All rights reserved.
//

#import "ServicesCollectionViewController.h"
#import "ServicesCollectionHeaderView.h"
#import "ServicesDetailViewController.h"
#import "DAO.h"
#import "Service.h"

@interface ServicesCollectionViewController (){
    NSArray *serviceImages, *servicesSectionNames;
}
@end

@implementation ServicesCollectionViewController {
    DAO *dao;
    NSMutableArray *servicesContent;
}

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
	// Do any additional setup after loading the view.
    
    self.title = @"Services";
    dao = [[DAO alloc] init];
    [dao createServicesDatabaseAndTable];
    servicesContent = [[NSMutableArray alloc] init];
    
    
        
    // Initialize all the image arrays for each service section.
    NSArray *venueBookingImages = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"full_breakfast.jpg", @"ham_and_cheese_panini.jpg", nil];
    
    NSArray *managementImages = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"full_breakfast.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", nil];

    NSArray *promotionAndMarketingImages = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"full_breakfast.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", nil];
    
    NSArray *rehearsalImages = [NSArray arrayWithObjects:@"egg_benedict.jpg", @"full_breakfast.jpg", nil];
    
    NSArray *technicalImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"green_tea.jpg", @"starbucks_coffee.jpg", nil];
    
    //add the image arrays for serviceImages
    serviceImages = [NSArray arrayWithObjects:venueBookingImages, managementImages,promotionAndMarketingImages, rehearsalImages, technicalImages, nil];
    
    //set service section names
    servicesSectionNames = [NSArray arrayWithObjects:@"Venue Booking", @"Management", @"Promotions & Marketing", @"Rehearsals", @"Technical", nil];
    
    int j;
    int max_service = 20;
    for (j = 0; j < max_service; j++) {
        //create the content to go into each service. 
        Service *_tmpService = [Service new];
        _tmpService.title  = [[NSString alloc] initWithFormat: @" %d service title.", j];
        _tmpService.info_1 = [[NSString alloc] initWithFormat: @"info_1 content for %d service.", j];
        _tmpService.info_2 = [[NSString alloc] initWithFormat: @"info_2 content for %d service.", j];
        _tmpService.info_3 = [[NSString alloc] initWithFormat: @"info_3 content for %d service.", j];
        
        //add in the Service object to servicesContent array.
        [servicesContent addObject:_tmpService];
    }
    NSLog(@"About to call saveServicesData:servicesArray");
    [dao saveServicesData:servicesContent];

    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[serviceImages objectAtIndex:section] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *serviceImageView = (UIImageView *)[cell viewWithTag:100];
    //recipeImageView.image = [UIImage imageNamed:[recipeImages[indexPath.section][indexPath.row]];
    serviceImageView.image = [UIImage imageNamed:[serviceImages objectAtIndex:indexPath.section][indexPath.row]];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];

    // this is called when user selects a particular image. it results
    // in a red border being illuminated to signify a touch event.
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame-selected.png"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [serviceImages count];
}



//from CollectionViewDataSource protocol: method needed to display header & footer images/labels.
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ServicesCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:@"%@", servicesSectionNames[indexPath.section]];
        headerView.title.text = title;
        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showServiceDetail"]) {
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        ServicesDetailViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        destViewController.serviceImageName = [serviceImages[indexPath.section] objectAtIndex:indexPath.row];
        
        NSMutableArray *tmp_all_services_array = [dao getAllServices];
        
        //this holds the absolute index value for the item in the collection view
        int absolute_item_no = 0;
        
        //holds the number of items in all previous sections
        int no_of_items_in_prev_sections = 0;
        
        //loop over previous sections to add in each's no of rows
        //to get no_of_items_in_prev_sections value.
        for (int j = 0; j < indexPath.section; j++) {
            no_of_items_in_prev_sections += [self collectionView:self.collectionView numberOfItemsInSection:j];
        }
        
        absolute_item_no = no_of_items_in_prev_sections + indexPath.row;

        NSLog(@"indexPath.row = %d, indexPath.section = %d, no_of_items_in_prev_sections = %d, absolute_item_no = %d", indexPath.row, indexPath.section, no_of_items_in_prev_sections, absolute_item_no);
        
        destViewController.theSelectedService = [tmp_all_services_array objectAtIndex:absolute_item_no];
        
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    }
    
    //[dao dropServicesTable];

}

@end
