//
//  ViewController.m
//  SelectMenu
//
//  Created by fyc on 16/8/31.
//  Copyright © 2016年 FuYaChen. All rights reserved.
//
//当前屏幕大小
#define SCREEN_SIZE   [[UIScreen mainScreen] bounds].size
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#import "ViewController.h"
#import "FileModel.h"
//#import "DocumentLoadVC.h"
#import "TableViewHeaderView.h"
#import "FileCell.h"
#import "FileKindCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
@property (nonatomic, retain)UITableView *fileTable;
@property (nonatomic, retain)UITableView *fileKindTable;
@property (nonatomic, retain)NSMutableArray *fileList;
@property (nonatomic, retain)NSMutableDictionary *fileDic;

@end

@implementation ViewController

- (NSMutableArray *)fileList{
    if (!_fileList) {
        _fileList = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _fileList;
}
- (UITableView *)fileKindTable{
    if (!_fileKindTable) {
        _fileKindTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
        _fileKindTable.delegate = self;
        _fileKindTable.dataSource = self;
//        [_fileKindTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kindCell"];
        [_fileKindTable registerNib:[UINib nibWithNibName:@"FileKindCell" bundle:nil] forCellReuseIdentifier:@"FileKindCell"];
        
        _fileKindTable.tableFooterView = [[UIView alloc]init];
    }
    return _fileKindTable;
}
- (UITableView *)fileTable{
    if (!_fileTable) {
        _fileTable = [[UITableView alloc]initWithFrame:CGRectMake(80, 0, SCREEN_SIZE.width - 80, SCREEN_SIZE.height - 64) style:UITableViewStylePlain];
        _fileTable.delegate = self;
        _fileTable.dataSource = self;
//        _fileTable.separatorColor = [UIColor clearColor];
        [_fileTable registerNib:[UINib nibWithNibName:@"FileCell" bundle:nil] forCellReuseIdentifier:@"FileCell"];
//        [_fileTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FileCell"];
        
        _fileTable.tableFooterView = [[UIView alloc]init];
    }
    return _fileTable;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.fileKindTable) {
        return 1;
    }else{
        return self.fileDic.allKeys.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.fileKindTable) {
        return self.fileDic.allKeys.count;
    }
    NSMutableArray *arr = [[self.fileDic allValues] objectAtIndex:section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.fileKindTable) {
        FileKindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileKindCell"];
        cell.name.text = [[self.fileDic allKeys] objectAtIndex:indexPath.row];
        return cell;
    }else{
        FileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell"];
        FileModel *file = [self.fileDic allValues][indexPath.section][indexPath.row];
        cell.model = file;
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.fileTable)
    {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.fileTable)
    {
        TableViewHeaderView *view = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 20)];
        view.name.text = [self.fileDic allKeys][section];
        return view;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.fileKindTable) {
        
        _selectIndex = indexPath.row;
        [UIView animateWithDuration:0.3 animations:^{
            [self.fileKindTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } completion:^(BOOL finished) {
            [self.fileTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }];
        
    }else{
        //    DocumentLoadVC *vc = [[DocumentLoadVC alloc]init];
        //    FileModel *model = self.fileList[indexPath.row];
        //    vc.title = model.fileName;
        //    vc.currentFileModel = model;
        //    [self.navigationController pushViewController:vc animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     FileModel *model = self.fileList[indexPath.row];
     
     //移除数据源
     [self.fileList removeObject:model];
     
     //删除本地
     if (model.fileAbsolutePath) {
     [[NSFileManager defaultManager]removeItemAtPath:model.fileAbsolutePath error:nil];
     //删除本地文件记录
     //        NSArray *saveFiles = [NSArray arrayWithArray:self.fileList];
     
     NSMutableArray *files = [[NSMutableArray alloc]initWithCapacity:0];
     for (FileModel *file in self.fileList) {
     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:file];
     [files addObject:data];
     }
     NSArray *historyFiles = [NSArray arrayWithArray:files];
     
     [[NSUserDefaults standardUserDefaults]setObject:historyFiles forKey:@"historyFiles"];
     
     }
     
     //移除tableView中的数据
     [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
     */
}
// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((self.fileTable == tableView) && !_isScrollDown && self.fileTable.dragging)
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((self.fileTable == tableView) && _isScrollDown && self.fileTable.dragging)
    {
        [self selectRowAtIndexPath:section + 1];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self setBaseVCAttributesWith:@"历史文件" left:nil right:nil WithInVC:self];
    
    if (IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
    [self docLsCreateSourceData];
    
}
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.fileKindTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}
#pragma mark - 生成数据源
/** 生成数据源 */
- (void)docLsCreateSourceData {
    // 如果是 从appDelegate里面，跳转过来， 主要用于打开别的软件的共享过来的文档；
    [self.view addSubview:self.fileTable];
    [self.view addSubview:self.fileKindTable];
    /*
     NSMutableArray *files = [[NSMutableArray alloc]initWithCapacity:0];
     NSArray *historyFiles = [[NSUserDefaults standardUserDefaults]objectForKey:@"historyFiles"];
     for (NSData *data in historyFiles) {
     FileModel *file = [NSKeyedUnarchiver unarchiveObjectWithData:data];
     [files addObject:file];
     }
     
     self.fileList = files;
     */
   
    self.fileDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    for (int i = 0; i < 20; i ++ ) {
        NSMutableArray *arr3 = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < 7; i ++ ) {
            FileModel *file = [[FileModel alloc]init];
            file.fileName = [NSString stringWithFormat:@"jilei%d",i];
            [arr3 addObject:file];
        }
        [self.fileDic setObject:arr3 forKey:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSLog(@"self===%@",self.fileDic);
    
}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scroll====%f",scrollView.contentOffset.y);
    static CGFloat beforeOffsetY = 0;
    if (self.fileTable == (UITableView *)scrollView) {
        _isScrollDown = beforeOffsetY < scrollView.contentOffset.y;
        beforeOffsetY = scrollView.contentOffset.y;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
