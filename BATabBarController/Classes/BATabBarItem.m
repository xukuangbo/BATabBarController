//The MIT License (MIT)
//
//Copyright (c) 2016 Bryan Antigua <antigua.b@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#define OUTLINE_RADIUS_PADDING 5
#define OUTLINE_PADDING 5
#define TITLE_OFFSET 5
#define IOS_TAB_BAR_HEIGHT 49

#define ICON_PADDING_NO_TEXT -15
#define ICON_PADDING_WITH_TEXT -25

#import "BATabBarItem.h"
#import "Masonry.h"

@interface  BATabBarItem()

@property(nonatomic,strong)CAShapeLayer *outerCircleLayer;

@end
@implementation BATabBarItem

#pragma mark - Lifecyle

- (id)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    
    self = [self init];
    if (self) {
        [self customInitWithImage:image selectedImage:selectedImage];
    }
    return self;
    
    
}

- (id)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage  title:(NSAttributedString*)title {
    
    self = [self init];
    if (self) {
        
        self.title = [[UILabel alloc] init];
        self.title.attributedText = title;
        self.title.adjustsFontSizeToFitWidth = YES;
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.numberOfLines = 0;
        
        [self customInitWithImage:image selectedImage:selectedImage];

    }
    return self;
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

-(void)orientationChanged:(NSNotification *)notification {
    if(self.outerCircleLayer){
        [self showOutline];
    }
}

- (void)updateConstraints {
    //tabbar item constraints
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.superview.mas_bottom);
        make.top.equalTo(self.superview.mas_top);
        make.height.equalTo(@(IOS_TAB_BAR_HEIGHT));
    }];
    
    //inner tabbar item constraints
    [self.innerTabBarItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.innerTabBarItem.superview.mas_top).offset(OUTLINE_PADDING);
        make.bottom.equalTo(self.innerTabBarItem.superview.mas_bottom).offset(-OUTLINE_PADDING);
        make.center.equalTo(self.innerTabBarItem.superview);
        make.height.equalTo(self.innerTabBarItem.mas_width);
    }];
    
    [super updateConstraints];
}


#pragma mark - Private

- (void)customInitWithImage:(UIImage*)unselectedImage selectedImage:(UIImage*)selectedImage {
    //since we're animating the layer, we need to redraw when we rotate the device
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    //create inner tab bar item
    self.innerTabBarItem = [[UIButton alloc] init];
    [self addSubview:self.innerTabBarItem];
    self.innerTabBarItem.userInteractionEnabled = NO;//allows for clicks to pass through to the button below
    self.innerTabBarItem.translatesAutoresizingMaskIntoConstraints = NO;
    
    //create selected icon
    self.selectedImageView = [[UIImageView alloc] initWithImage:selectedImage];
    self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.innerTabBarItem addSubview:self.selectedImageView];
    
    //create unselected icon
    self.unselectedImageView = [[UIImageView alloc] initWithImage:unselectedImage];
    self.unselectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.innerTabBarItem addSubview:self.unselectedImageView];
    
    [self addConstraintsToImageViews];
}

-(void)addConstraintsToImageViews {
    
    if(!self.title){
        
        //selected images contraints
        [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.selectedImageView.superview);
            make.width.equalTo(self.selectedImageView.superview.mas_width).offset(ICON_PADDING_NO_TEXT);
            make.height.equalTo(self.selectedImageView.superview.mas_height).offset(ICON_PADDING_NO_TEXT);
            
        }];
        
        //unselected images
        [self.unselectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.unselectedImageView.superview);
            make.width.equalTo(self.unselectedImageView.superview.mas_width).offset(ICON_PADDING_NO_TEXT);
            make.height.equalTo(self.unselectedImageView.superview.mas_height).offset(ICON_PADDING_NO_TEXT);
            
        }];
        
    } else {
        
        [self.innerTabBarItem addSubview:self.title];

        //title constraints
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.title.superview.mas_centerX);
            make.bottom.equalTo(self.title.superview.superview.mas_bottom).offset(-TITLE_OFFSET);
            make.top.equalTo(self.unselectedImageView.mas_bottom).offset(TITLE_OFFSET);
        }];
        
        //selected images contraints
        [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedImageView.superview.mas_top).offset(TITLE_OFFSET);
            make.centerX.equalTo(self.selectedImageView.superview.mas_centerX);
            make.width.equalTo(self.selectedImageView.superview.mas_width).offset(ICON_PADDING_WITH_TEXT);
            make.height.equalTo(self.selectedImageView.superview.mas_height).offset(ICON_PADDING_WITH_TEXT);
            
        }];
        
        //unselected images constraints
        //selected images contraints
        [self.unselectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectedImageView.superview.mas_top).offset(TITLE_OFFSET);
            make.centerX.equalTo(self.selectedImageView.superview.mas_centerX);
            make.width.equalTo(self.selectedImageView.superview.mas_width).offset(ICON_PADDING_WITH_TEXT);
            make.height.equalTo(self.selectedImageView.superview.mas_height).offset(ICON_PADDING_WITH_TEXT);
            
        }];
        
    }
}

#pragma mark - Public

-(void)showOutline {
    
    [self layoutIfNeeded];
    
    //redraws in case constraints have changed
    if(self.outerCircleLayer){
        [self.outerCircleLayer removeFromSuperlayer];
        self.outerCircleLayer = nil;
    }
    self.outerCircleLayer = [CAShapeLayer layer];
    
    
    //path for the outline
    UIBezierPath *outerCircleBezierPath = [UIBezierPath bezierPath];
    
    double outlineRadius = self.title?CGRectGetWidth(self.unselectedImageView.frame)/2.0 + OUTLINE_RADIUS_PADDING : (CGRectGetWidth(self.unselectedImageView.frame) - ICON_PADDING_NO_TEXT)/2;
    
    //path for the outline
    [outerCircleBezierPath addArcWithCenter:self.unselectedImageView.center radius:outlineRadius startAngle:M_PI/2 endAngle:M_PI clockwise:NO];
    [outerCircleBezierPath addArcWithCenter:self.unselectedImageView.center radius:outlineRadius startAngle:M_PI  endAngle:M_PI/2 clockwise:NO];
    
    //adding custom color and stroke
    self.outerCircleLayer.path = outerCircleBezierPath.CGPath;
    self.outerCircleLayer.strokeColor = self.strokeColor.CGColor;
    self.outerCircleLayer.fillColor = [UIColor clearColor].CGColor;
    self.outerCircleLayer.lineWidth = self.strokeWidth;
    [self.innerTabBarItem.layer addSublayer:self.outerCircleLayer];
    
    
    //fade in icon color
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    self.unselectedImageView.alpha = 0.0;
    [UIView commitAnimations];
    
}

-(void)hideOutline {
    
    //if showing then hide
    if(self.outerCircleLayer){
        [self.outerCircleLayer removeFromSuperlayer];
        self.outerCircleLayer = nil;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1];
        self.unselectedImageView.alpha = 1.0;
        [UIView commitAnimations];
        return;
    }
}

@end