//
//  TTInterativeTextView.m
//  TTDemo
//
//  Created by liuxj on 2018/5/2.
//  Copyright © 2018年 iwm. All rights reserved.
//

#import "TTInterativeTextView.h"
#import "TTSimpleRouter.h"

@interface TTInterativeTextView ()<UITextViewDelegate>

@end

@implementation TTInterativeTextView

#pragma mark - Life Circle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.editable = NO;
        self.scrollEnabled = NO;
        self.textContainerInset = UIEdgeInsetsZero;
        self.linkTextAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    }
    return self;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(nonnull NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [TTSimpleRouter openURL:URL];
    return NO;
}

@end
