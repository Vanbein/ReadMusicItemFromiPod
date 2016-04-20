//
//  ViewController.m
//  ReadMusicItemFromiPod
//
//  Created by 王斌 on 16/4/20.
//  Copyright © 2016年 Changhong electric Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "VNBMusicManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    VNBMusicManager *model = [[VNBMusicManager alloc] init];
    [model readMusicItemsFromeAlbumCompletion:^(NSMutableArray *musicArray, NSError *error) {
        NSLog(@"%lu", (unsigned long)[musicArray count]);
        self.dataSource = [NSArray arrayWithArray:musicArray];
        CGRect frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }];
    
    
}

- (void)convertMediaPickerController{

    //MPMediaPicker
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    picker.prompt = @"请选择需要播放的歌曲";
    picker.showsCloudItems = NO;
    picker.allowsPickingMultipleItems = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MPMediaPicker Controller Delegate

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    //do something
}

#pragma mark - TableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    VNBMusicItem *musicItem = self.dataSource[indexPath.row];
    
    if (musicItem.thumbnail) {
        cell.imageView.image = musicItem.thumbnail;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"def_img"];
    }
    cell.textLabel.text = musicItem.trackName;
    
    NSString *artistName = @"unknow";
    NSString *albumName = @"unknow album";
    NSLog(@"musicItem.artistName:%@",musicItem.artistName);
    if (![musicItem.artistName isEqualToString:@""]) {
        artistName = musicItem.artistName;
    }
    if (![musicItem.albumName isEqualToString:@""]) {
        albumName = musicItem.albumName;
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", artistName, albumName];

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
