//
//  TextureChecker.hpp
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/16.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

#ifndef TextureChecker_hpp
#define TextureChecker_hpp

#include <stdio.h>
#include <vector>
#include <map>
#include <string>

extern std::map<std::string, int>* loadded_texture;

bool check_texture(std::string name);

void update_texturemap(std::string name, int textureid);

int get_texture(std::string name);

#endif /* TextureChecker_hpp */
