//
//  ViewController.m
//  AppExtensition
//
//  Created by 李伟 on 16/9/2.
//  Copyright © 2016年 TFLH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIImage *image;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor  =[UIColor purpleColor];
       [self appExt];
}

-(void)appExt{

    
    NSUserDefaults *defau = [[NSUserDefaults alloc]initWithSuiteName:@"group.lw.ext"];
    [defau setObject:@"李伟" forKey:@"name"];
    [defau synchronize];
   self.image= [UIImage imageNamed:@"bidBase_clock@3x.png"];
    
    NSUserDefaults *defau2 = [[NSUserDefaults alloc]initWithSuiteName:@"group.lw.ext"];
    [defau2 synchronize];
    [defau2 setObject:UIImageJPEGRepresentation(self.image, 0) forKey:@"img"];
    
    [defau synchronize];
    UILabel *ext = [[UILabel alloc]initWithFrame:CGRectMake(90, 90, 200, 20)];
    ext.textColor = [UIColor redColor];
    ext.text = @"呵呵呵呵";
    [self.view addSubview:ext];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
