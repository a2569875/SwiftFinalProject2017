//
//  TextureChecker.cpp
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/16.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

#include "TextureChecker.hpp"

extern std::map<std::string, int>* loadded_texture;
std::map<std::string, int>* loadded_texture = nullptr;

bool check_texture(std::string name){
    if(loadded_texture == nullptr){
        loadded_texture = new std::map<std::string, int>();
        return false;
    }
    auto test = loadded_texture->find(name);
    if (test == loadded_texture->end()) return false;
    return true;
}

void update_texturemap(std::string name, int textureid){
    (*loadded_texture)[name] = textureid;
}

int get_texture(std::string name){
    if(loadded_texture == nullptr){
        loadded_texture = new std::map<std::string, int>();
        return -1;
    }
    auto test = loadded_texture->find(name);
    if (test == loadded_texture->end()) return -1;
    return test->second;
}
