//
//  BookingScheduleRowView.swift
//  MorfiTimeLocal
//
//  Created by Marcos Vitureira on 13/10/2021.
//

import SwiftUI

struct BookingScheduleRowView: View {
    
    var bookingSchedule: BookingSchedule
    
    var body: some View {
        ZStack {
            Constants.grayLight
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(bookingSchedule.schedule).foregroundColor(Color.black)
                    if Int(bookingSchedule.capacity) == 1 {
                        Text("Quedan 1 lugar").foregroundColor(Color.green)
                    } else {
                        Text("Quedan \(bookingSchedule.capacity) lugares").foregroundColor(Color.green)
                    }
                }
                Spacer()
                VStack(spacing: 5) {
                    Image(systemName: "figure.wave").foregroundColor(Constants.salmonDark)
                    Text("Reservar").foregroundColor(Constants.salmonDark)
                }
            }.padding(.leading, 15).padding(.trailing, 15).padding(.top, 10).padding(.bottom, 10)
        }
    }
}

struct BookingScheduleRowView_Previews: PreviewProvider {
    static var previews: some View {
        BookingScheduleRowView(bookingSchedule: BookingSchedule()).previewLayout(.fixed(width: 300, height: 60))
    }
}
