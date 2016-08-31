//
//  FileKindCell.m
//  Nexfi
//
//  Created by fyc on 16/8/31.
//  Copyright © 2016年 FuYaChen. All rights reserved.
//

#import "FileKindCell.h"


@implementation FileKindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
    self.name.numberOfLines = 0;
    
    self.name.font = [UIFont systemFontOfSize:15];
    self.name.textColor = [UIColor redColor];
    self.name.highlightedTextColor = [UIColor blueColor];
    [self.contentView addSubview:self.name];
    
    self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 44)];
    self.yellowView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:self.yellowView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
