//
//  ViewController.m
//  TTDemo
//
//  Created by liuxj on 2018/5/2.
//  Copyright © 2018年 iwm. All rights reserved.
//

#import "ViewController.h"
#import "TTInterativeTextView.h"
#import "TTLinkParser.h"

@interface ViewController ()

@property (nonatomic, strong) TTInterativeTextView *textView;

@end

@implementation ViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViews];
}

#pragma mark - Configure View

- (void)configureViews {
    self.title = @"Demo";
    
    [self.view addSubview:self.textView];
    NSString *content = @"欢迎使用探探，在使用过程中有疑问请<a herf=\"tantanapp://feedback\">反馈</a>";
    
    //异步解析，避免阻塞主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSAttributedString *contentAttString = [[TTLinkParser sharedParser] parsedLinkAttributedStringWithContent:content];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.attributedText = contentAttString;
            self.textView.bounds = CGRectMake(0, 0, 200, 0);
            [self.textView sizeToFit];
            self.textView.frame = CGRectMake(50, 80, CGRectGetWidth(self.textView.frame), CGRectGetHeight(self.textView.frame));
        });
    });
}


#pragma mark - Getter & Setter

- (TTInterativeTextView *)textView {
    if (!_textView) {
        _textView = [[TTInterativeTextView alloc] init];
    }
    return _textView;
}

@end
