//
//  ViewController.m
//  TableViewDemo
//
//  Created by 张雪东 on 16/4/20.
//  Copyright © 2016年 ZXD. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeigth [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,assign) CGFloat yOffset;

@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) UITableView *tableView3;

@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeigth)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeigth);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    self.tableView1 = [self createTableViewAtIndex:0];
    [scrollView addSubview:_tableView1];
    
    self.tableView2 = [self createTableViewAtIndex:1];
    [scrollView addSubview:_tableView2];
    
    self.tableView3 = [self createTableViewAtIndex:2];
    [scrollView addSubview:_tableView3];
    
    [self createheaderView];
}

//创建页面头
-(void)createheaderView{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:[self createTabView]];
    self.yOffset = headerView.center.y;
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 30)];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"写了10100字，获得100个喜欢";
    [headerView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 100, 40);
    btn.center = CGPointMake(label.center.x, label.center.y + 40);
    [btn setTitle:@"编辑个人资料" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [headerView addSubview:btn];
}

//创建tablView
-(UITableView *)createTableViewAtIndex:(NSInteger)index{

    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth , 0, kScreenWidth, 260)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * index, 0, kScreenWidth, kScreenHeigth)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableHeaderView = tableHeaderView;
    tableView.tag = 2000 + index;
    return tableView;
}

//创建tab视图
-(UIView *)createTabView{

    NSArray *arr = @[@"动态",@"文章",@"更多"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 60)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    
    CGFloat space = (kScreenWidth - 120) / 6;
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(space + (2*space + 40) * i, 0, 40, 60);
        [btn addTarget:self action:@selector(changView:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [view addSubview:btn];
    }
    return view;
}

-(void)changView:(UIButton *)btn{

    NSInteger index = btn.tag - 1000;
    [self.scrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:NO];
}

#pragma mark -- UITableView代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag == 2000) {
        return 130;
    }else if(tableView.tag == 2001){
        return 150;
    }else{
        return 60;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zxd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zxd"];
    }
    if (tableView.tag == 2000) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld 发表了文章",(long)indexPath.row];
    }else if(tableView.tag == 2001){
        cell.textLabel.text = [NSString stringWithFormat:@"关于%ld的文章",(long)indexPath.row];
    }else{
        cell.textLabel.text = @"喜欢的文章";
    }
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if ([scrollView isEqual:self.scrollView]) {
        return;
    }
    if (scrollView.contentOffset.y > 200) {
        self.headerView.center = CGPointMake(_headerView.center.x, self.yOffset - 200);
        return;
    }
    CGFloat h = self.yOffset - scrollView.contentOffset.y;
    self.headerView.center = CGPointMake(_headerView.center.x, h);

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if ([scrollView isEqual:self.scrollView]) {
        return;
    }
    
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if ([scrollView isEqual:self.scrollView]) {
        return;
    }
    [self setTableViewContentOffsetWithTag:scrollView.tag contentOffset:scrollView.contentOffset.y];
}

//设置tableView的偏移量
-(void)setTableViewContentOffsetWithTag:(NSInteger)tag contentOffset:(CGFloat)offset{

    CGFloat tableViewOffset = offset;
    if(offset > 200){
        
        tableViewOffset = 200;
    }
    if (tag == 2000) {
        
        [self.tableView2 setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        [self.tableView3 setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }else if(tag == 2001){
        
        [self.tableView1 setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        [self.tableView3 setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }else{
        
        [self.tableView1 setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
        [self.tableView2 setContentOffset:CGPointMake(0, tableViewOffset) animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
