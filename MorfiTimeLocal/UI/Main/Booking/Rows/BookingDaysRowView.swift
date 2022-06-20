//
//  BookingDayRowView.swift
//  MorfiTimeLocal
//
//  Created by Marcos Vitureira on 09/10/2021.
//

import SwiftUI

struct BookingDaysRowView: View {
    
    var bookingDays: String
    
    var body: some View {
        ZStack {
            Spacer()
            Constants.grayDark
            VStack {
                Spacer()
                Text(bookingDays.prefix(3)).bold().font(.title3).foregroundColor(Constants.salmonRegular)
                Spacer()
                Text(bookingDays.prefix(6).suffix(2)).bold().font(.largeTitle).foregroundColor(Constants.creamDark)
                Spacer()
                Text(bookingDays.suffix(3)).bold().font(.title3).foregroundColor(Constants.creamLight)
                Spacer()
            }.padding(10)
            Spacer()
        }.cornerRadius(10)
    }
}

struct BookingDaysRowView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDaysRowView(bookingDays: "Lun 01 Ene").previewLayout(.fixed(width: 80, height: 130))
    }
}
