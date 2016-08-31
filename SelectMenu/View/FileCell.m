//
//  FileCell.m
//  Nexfi
//
//  Created by fyc on 16/8/31.
//  Copyright © 2016年 FuYaChen. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
    [self.contentView addSubview:self.imageV];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 30)];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 30)];
    self.priceLabel.font = [UIFont systemFontOfSize:14];
    self.priceLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.priceLabel];
    
}
- (void)setModel:(FileModel *)model{
    self.nameLabel.text = model.fileName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
