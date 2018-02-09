//
//  ViewController.m
//  TableViewSectionIndexChangeCallback
//
//  Created by sischen on 2018/2/9.
//  Copyright © 2018年 pcbdoor.com. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+IndexPan.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray <NSString *> *stringSource;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *indexIndicatorLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indexIndicatorLabel];
    
    __weak typeof(self) weakself = self;
    self.tableView.sectionIndexChanged = ^(NSInteger sectionIndex, BOOL isTracking) {
        weakself.indexIndicatorLabel.hidden = !isTracking;
        weakself.indexIndicatorLabel.text = !isTracking ? nil : [weakself sectionIndexTitlesForTableView:weakself.tableView][sectionIndex];
    };
}

#pragma mark -
#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.stringSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    headerView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.bounds.size.width-15, headerView.bounds.size.height)];
    label.text = self.stringSource[section];
    label.font = [UIFont boldSystemFontOfSize:15];
    [headerView addSubview:label];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    NSString *str = self.stringSource[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", str,str,str];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.stringSource;
}

//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    NSLog(@"滑动到索引文字：%@", title); // 缺点：无法获取触摸结束等事件
//    return index;
//}

#pragma mark - getter/setter
-(UITableView *)tableView{
    if (_tableView) { return _tableView; }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height-20) style:UITableViewStylePlain];
    _tableView.sectionIndexColor = [UIColor blueColor];
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self; _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    return _tableView;
}

-(NSArray<NSString *> *)stringSource{
    if (_stringSource) { return _stringSource; }
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:26];
    for (int i = 0; i < 26; i++) {
        [res addObject:[NSString stringWithFormat:@"%c", ('A' + i)]];
    }
    return (_stringSource = [NSArray<NSString *> arrayWithArray:res]);
}

-(UILabel *)indexIndicatorLabel{
    if (_indexIndicatorLabel) { return _indexIndicatorLabel; }
    _indexIndicatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
    _indexIndicatorLabel.center = CGPointMake(CGRectGetMidX(UIScreen.mainScreen.bounds), CGRectGetMidY(UIScreen.mainScreen.bounds));
    _indexIndicatorLabel.font = [UIFont boldSystemFontOfSize:32];
    _indexIndicatorLabel.textColor = [UIColor blueColor];
    _indexIndicatorLabel.hidden = YES;
    _indexIndicatorLabel.textAlignment = NSTextAlignmentCenter;
    _indexIndicatorLabel.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _indexIndicatorLabel.layer.shadowOffset = CGSizeMake(5, 5);
    _indexIndicatorLabel.layer.shadowOpacity = 0.5;
    return _indexIndicatorLabel;
}

@end
