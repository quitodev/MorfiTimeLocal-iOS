//
//  BookingSectorRowView.swift
//  MorfiTimeLocal
//
//  Created by Marcos Vitureira on 09/10/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookingSectorRowView: View {
    
    var bookingSector: BookingSector
    
    var body: some View {
        VStack {
            Spacer()
            if bookingSector.image == Constants.empty {
                Image(Constants.image).circleImageWithBorder(width: 200, height: 200)
            } else {
                WebImage(url: URL(string: bookingSector.image)).placeholder { ProgressView() }
                    .circleWebImageWithBorder(width: 200, height: 200)
            }
            Text(bookingSector.name).bold().font(.title3).foregroundColor(.white)
            Spacer()
        }
    }
}

struct BookingSectorRowView_Previews: PreviewProvider {
    static var previews: some View {
        BookingSectorRowView(bookingSector:BookingSector()).previewLayout(.fixed(width: 200, height: 200))
    }
}
