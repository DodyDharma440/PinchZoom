//
//  ControlImageView.swift
//  PinchZoom
//
//  Created by Dodi Aditya on 28/04/23.
//

import SwiftUI

struct ControlImageView: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 36))
    }
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(icon: "minus.magnifyingglass")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
