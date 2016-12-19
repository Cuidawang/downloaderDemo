//
//  ViewController.m
//  DownloaderDemo
//
//  Created by Cuikeyi on 2016/12/19.
//  Copyright © 2016年 xiaohongchun. All rights reserved.
//

#import "ViewController.h"
#import "DownloaderModel.h"
#import "DownloaderCell.h"
#import "XHCDownloader.h"
#import "XHCDownloaderManager.h"

#define SCR_WIDTH       [[UIScreen mainScreen] bounds].size.width
#define SCR_HEIGHT      [[UIScreen mainScreen] bounds].size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self initView];
}

- (void)initView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, SCR_WIDTH, SCR_HEIGHT-20) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[DownloaderCell class] forCellReuseIdentifier:@"cell"];
        tableView;
    });
    
    [self.view addSubview:_tableView];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloaderModel *model = self.datas[indexPath.row];
    DownloaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloaderModel *model = self.datas[indexPath.row];
    [[XHCDownloaderManager shareInstall] downloadPathWithDownloaderModel:model];
}

- (NSArray *)datas
{
    if (!_datas) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        NSArray *videoArray = @[
                                @"http://v.xiaohongchun.com/69424EA553F573EB",
                                @"http://v.xiaohongchun.com/0003129D6A53C168.mp4",
                                @"http://v.xiaohongchun.com/B39091883224DC83",
                                @"http://v.xiaohongchun.com/C01958DDF3401DEC",
                                @"http://v.xiaohongchun.com/BBF10FBD3A3DA18E",
                                ];
        for (int i = 0; i < 5; i++) {
            DownloaderModel *model = [[DownloaderModel alloc] init];
            model.title = [NSString stringWithFormat:@"download-->%zd", i];
            model.url = videoArray[i];
            model.imageUrl = @"http://v.xiaohongchun.com/7B224F00E7B91FE9-cover1.jpg";
            model.progress = @([XHCDownloader localFileDownloadScaleWithUrl:model.url]);
            [array addObject:model];
        }
        
        _datas = [array copy];
    }
    return _datas;
}

@end
