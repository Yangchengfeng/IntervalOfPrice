//
//  ViewController.m
//  IntervalOfPrice
//
//  Created by 阳丞枫 on 16/11/2.
//  Copyright © 2016年 chengfengYang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
{
    int time;
}

@property (weak, nonatomic) IBOutlet UITextField *lowPrice;
@property (weak, nonatomic) IBOutlet UITextField *highPrice;
@property (nonatomic, strong) NSString *highP;
@property (nonatomic, strong) NSString *lowP;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) NSTimer *myTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置代理
    _lowPrice.delegate = self;
    _highPrice.delegate = self;
    
    // 创建“完成”按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 7, 80, 30)];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor grayColor].CGColor;
    [button setTitle:@"完成"forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(refreshPriceInterval) forControlEvents:UIControlEventTouchUpInside];
    
    // 给textField添加inputAccessoryView
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [view setBackgroundColor: [UIColor colorWithRed:210/250.0 green:214/250.0 blue:220/250.0 alpha:1.0]];
    [view addSubview:button];
    _lowPrice.inputAccessoryView = view;
    _highPrice.inputAccessoryView = view;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.color = [UIColor grayColor];
    _activityIndicatorView.frame = self.view.bounds;
    [self.view addSubview:_activityIndicatorView];
}

- (void)refreshPriceInterval {
    time = 2; // 注意time的位置
    
    [_lowPrice resignFirstResponder];
    [_highPrice resignFirstResponder];
    
    if((![_lowPrice.text isEqualToString:@""]) && (![_highPrice.text isEqualToString:@""])) {
        if([_lowPrice.text integerValue] > [_highPrice.text integerValue]) {
            _lowP = _highPrice.text;
            _highP = _lowPrice.text;
        }
    } else {
        _lowP = _lowPrice.text;
        _highP = _highPrice.text;
    }
    
    // 把_lowP _highP传入某个拉去后台数据的方法中
    
    [_activityIndicatorView startAnimating];
    
    [self hideActivityIndicatorView];
}

- (void)hideActivityIndicatorView {
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}

- (void)updateTimer {
    time--; // 这个地方模拟拉取网络数据(更新成对应价格区间的商品)所需的时间
    
    // 判断是否没时间了
    if (time == 0) {
        _lowPrice.text =  _lowP ;
        _highPrice.text = _highP;
        [self.myTimer invalidate];
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_lowPrice resignFirstResponder];
    [_highPrice resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
