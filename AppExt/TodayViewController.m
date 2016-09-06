//
//  TodayViewController.m
//  AppExt
//
//  Created by 李伟 on 16/9/2.
//  Copyright © 2016年 TFLH. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *testWidget;
@property (weak, nonatomic) IBOutlet UIImageView *widetImage;
@property(nonatomic,strong)UIImageView *widgetIma;
@property(nonatomic,strong)UITableView *tablewidet;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self widgetUI];
       [self.view addSubview:self.widgetIma];
   // self.view.backgroundColor = [UIColor yellowColor];
     self.preferredContentSize = CGSizeMake(0, 300);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self.testWidget addGestureRecognizer:tap];
    self.testWidget.layer.shadowOffset = CGSizeMake(0, 10);
    self.testWidget.layer.shadowColor  =[UIColor cyanColor].CGColor;
    self.testWidget.layer.shadowOpacity = 1;
   // self.testWidget.backgroundColor = [UIColor purpleColor];
    NSUserDefaults *defau = [[NSUserDefaults alloc]initWithSuiteName:@"group.lw.ext"];
    NSString *name= [defau objectForKey:@"name"];
   self.testWidget.text = name;
    self.testWidget.textColor = [UIColor greenColor];
    self.widetImage.image = [UIImage imageWithData:[defau objectForKey:@"img"]];
    self.widetImage.clipsToBounds  =YES;
    self.widetImage.layer.cornerRadius = 30;
    
    self.tablewidet = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    self.tablewidet.delegate = self;
    self.tablewidet.dataSource = self;
    
    [self.view addSubview:self.tablewidet];
    
//    self.widetImage.image = [UIImage imageNamed:@"bidBase_clock@3x.png"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *identifier = @"CELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    return cell;
}
-(void)click:(UITapGestureRecognizer *)tap{

    NSLog(@"click");
    
    [self.extensionContext openURL:[NSURL URLWithString:@"widetIOS://lw"] completionHandler:^(BOOL success) {
        NSLog(@"suc");
    }];
    
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"open" object:nil];
    
}
-(void)widgetUI{
   
    self.widgetIma = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.widgetIma.image = [UIImage imageNamed:@"bidBase_clock.png"];
    [self.widgetIma sizeToFit];

    NSLog(@"%@",self.widgetIma);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{

    NSLog(@"%@",NSStringFromUIEdgeInsets(defaultMarginInsets));
    return UIEdgeInsetsMake(0, 16, 0, 0);
}
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
