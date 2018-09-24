//
//  PlaceVietNam.swift
//  App
//
//  Created by Đừng xóa on 9/22/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import Foundation

class PlaceViewNam {
    var name: String
    var image: String
    var content: String
    
    init?(dictionary: DICT){
        guard let name = dictionary["name"] as? String else {return nil}
        guard let image = dictionary["image"] as? String else {return nil}
        guard let content = dictionary["content"] as? String else {return nil}
        
        self.name = name
        self.image = image
        self.content = content
    }
    
}
