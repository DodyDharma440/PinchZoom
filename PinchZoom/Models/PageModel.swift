//
//  PageModel.swift
//  PinchZoom
//
//  Created by Dodi Aditya on 30/04/23.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-\(imageName)"
    }
}
