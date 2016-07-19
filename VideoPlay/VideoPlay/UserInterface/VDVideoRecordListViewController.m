//
//  VDVideoRecordListViewController.m
//  VideoPlay
//
//  Created by 羊谦 on 16/7/19.
//  Copyright © 2016年 video. All rights reserved.
//

#import "VDVideoRecordListViewController.h"
#import "VDImagePickerViewController.h"
#import "VDCustomPickerViewController.h"

@interface VDVideoRecordListViewController ()

@end

@implementation VDVideoRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择视屏录制方式";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifer"];
    self.tableView.tableFooterView = [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifer" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"系统自带摄像机";
    }else{
        cell.textLabel.text =  @"自定义拍照界面";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        VDImagePickerViewController *vc = [[VDImagePickerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VDCustomPickerViewController *vc = [[VDCustomPickerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
