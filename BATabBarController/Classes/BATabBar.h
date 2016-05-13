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

#import <UIKit/UIKit.h>
#import "BATabBarItem.h"

@protocol BATabBarDelegate;

@interface BATabBar : UIView

/**
 Currently selected Tab
 */
@property(nonatomic, strong) BATabBarItem *currentTabBarItem;

/**
 Color of the outline when selected and during animations
 */
@property(nonatomic,strong)UIColor*barItemStrokeColor;

/**
 Width of the outline when selected and during animations
 */
@property(nonatomic,assign)CGFloat barItemLineWidth;

/**
 All Tabs in the tab bar
 */
@property(nonatomic,strong)NSArray<__kindof BATabBarItem *>*tabBarItems;

/**
 Delegate used to add external action to a tab bar click
 */
@property (nonatomic,weak) id<BATabBarDelegate> delegate;

/**
 Method used to change the selected Tab
 
 @param index
 Location of new tab
 @param animated
 Used to determine if we should animate to this tab
 */
-(void)selectedTabItem:(NSUInteger)index animated:(BOOL)animated;

@end

@protocol BATabBarDelegate <NSObject>

/**
 Delegate method used to add external action to a tab bar click
 
 @param tabBar
 Tab bar associated with this controller
 @param index
 Location of the Tab selected
 */
-(void)tabBar:(BATabBar*)tabBar didSelectItemAtIndex:(NSUInteger)index;

@end