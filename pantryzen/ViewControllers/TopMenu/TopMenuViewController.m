//
//  TopMenuViewController.m
//  pantryzen
//
//  Created by admin on 22/04/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "TopMenuViewController.h"
#import "TopMenuTableViewCell.h"

@interface TopMenuViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TopMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCartTableViewCell" forIndexPath:indexPath];
    //    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator.png"]];
    //    imgView.frame = CGRectMake(0, 103, 480, 10);
    //    [cell.contentView addSubview:imgView];
    
    
    NSString *productName = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:indexPath.item] objectForKey:@"name"];
    NSString *productPrice = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:indexPath.item] objectForKey:@"price"];
    NSString *productQty = [[[AppDelegate sharedInstance].arrMyCart objectAtIndex:indexPath.item] objectForKey:@"qty"];
    
    //    UIImageView *imgV = (UIImageView *)[self.view viewWithTag:100];
    cell.imgProduct.image = [UIImage imageNamed:productName];
    cell.lblProductName.text = productName;
    cell.lblProductQty.text = productQty;
    cell.lblProductPrice.text = productPrice;
    [cell.btnDelete addTarget:self action:@selector(onClickRemoveBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the row from data model
    [[AppDelegate sharedInstance].arrMyCart removeObjectAtIndex:indexPath.row];
    
    // Request table view to reload
    [tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
