//
//  ViewController.m
//  QYGLChatCell
//
//  Created by lixu on 2017/5/17.
//  Copyright © 2017年 lixu. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.textField addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.textField addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        UITextPosition * current = _textField.selectedTextRange.start;
        NSInteger location = [_textField offsetFromPosition:_textField.beginningOfDocument toPosition:current];
        
        if (location - 1 < 0) {
            location = [_textField offsetFromPosition:_textField.beginningOfDocument toPosition:_textField.endOfDocument];
            ++location;
        }
        
        [self setSelectedRange:NSMakeRange(--location, 0) text:self.textField];
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        UITextPosition * current = _textField.selectedTextRange.start;
        NSInteger location = [_textField offsetFromPosition:_textField.beginningOfDocument toPosition:current];
        [self setSelectedRange:NSMakeRange(++location, 0) text:self.textField];
    }
}

- (void) setSelectedRange:(NSRange) range text:(UITextField *) textField
{
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* startPosition = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [textField positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [textField textRangeFromPosition:startPosition toPosition:endPosition];
    [textField setSelectedTextRange:selectionRange];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
