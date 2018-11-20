//
//  ContentViewController.m
//  YLSliderTabberView
//
//  Created by yan on 2018/8/23.
//  Copyright © 2018年 yanlong. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UILabel *label;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITableView *tableview = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    label.textColor = [UIColor redColor];
//    label.font = [UIFont systemFontOfSize:20];
//    label.textAlignment = NSTextAlignmentCenter;
//    self.label = label;
//    [self.view addSubview:label];
//
//    NSLog(@"viewDidLoad");
    
}

- (void)setTitleString:(NSString *)titleString{
    self.label.text = titleString;
    [self.label sizeToFit];
    self.label.center = self.view.center;
}

- (void)dealloc{
    NSLog(@"dealloc--%@",self);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    NSString *title = [NSString stringWithFormat:@"cell-%ld",indexPath.row+1];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---didSelectRowAtIndexPath");
}


@end
