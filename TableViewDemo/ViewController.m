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
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeigth);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    self.tableView1 = [self createTableViewAtIndex:0];
    [scrollView addSubview:_tableView1];
    
    self.tableView2 = [self createTableViewAtIndex:1];
    [scrollView addSubview:_tableView2];
    
    self.tableView3 = [self createTableViewAtIndex:2];
    [scrollView addSubview:_tableView3];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    headerView.backgroundColor = [UIColor blueColor];
    [headerView addSubview:[self createTabView]];
    self.yOffset = headerView.center.y;
    self.headerView = headerView;
    [self.view addSubview:headerView];
}

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

-(UIView *)createTabView{

    NSArray *arr = @[@"动态",@"文章",@"更多"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 60)];
    view.backgroundColor = [UIColor redColor];
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor greenColor];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(40 + 120 * i, 10, 50, 40);
        [btn addTarget:self action:@selector(changView:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [view addSubview:btn];
    }
    return view;
}

-(void)changView:(UIButton *)btn{

    switch (btn.tag) {
        case 1000:{
        
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            
            break;
        case 1001:{
        
            [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        }
            
            break;
        case 1002:
            {
                
                [self.scrollView setContentOffset:CGPointMake(2 * kScreenWidth, 0) animated:YES];
            }
            break;
        
        default:
            break;
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
        cell.contentView.backgroundColor = [UIColor orangeColor];
    }else if(tableView.tag == 2001){
        cell.contentView.backgroundColor = [UIColor greenColor];
    }else{
        cell.contentView.backgroundColor = [UIColor blueColor];
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

-(void)setTableViewContentOffsetWithTag:(NSInteger)tag contentOffset:(CGFloat)offset{

    if (tag == 2000) {
        [self.tableView2 setContentOffset:CGPointMake(0, offset) animated:NO];
        [self.tableView3 setContentOffset:CGPointMake(0, offset) animated:NO];
    }else if(tag == 2001){
        [self.tableView1 setContentOffset:CGPointMake(0, offset) animated:NO];
        [self.tableView3 setContentOffset:CGPointMake(0, offset) animated:NO];
    }else{
        [self.tableView1 setContentOffset:CGPointMake(0, offset) animated:NO];
        [self.tableView2 setContentOffset:CGPointMake(0, offset) animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
