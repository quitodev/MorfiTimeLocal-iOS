//
//  BookingDetailView.swift
//  MorfiTimeLocal
//
//  Created by Marcos Vitureira on 26/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct BookingDetailView: View {
    
    // MARK: - VIEW MODEL
    @ObservedObject private var bookingViewModel: BookingViewModelImpl
    
    // MARK: - BOOLEANS
    @State private var isScrollingTop = false
    @State private var isChoosingPeople = false
    @State private var isBookingConfirmed = false
    
    // MARK: - VARIABLES
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var user: User
    @State private var table = ""
    @State private var comments = ""
    @State private var people = 1.0
    private var bookingSchedule: BookingSchedule
    
    init(viewModel: BookingViewModelImpl, booking: BookingSchedule) {
        bookingViewModel = viewModel
        bookingSchedule = booking
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { scrollViewReader in
                    ZStack {
                        VStack {
                            VStack {
                                // MARK: - TITLE
                                Text("Confirmá tu reserva").titleBlack()
                                
                                // MARK: - BOOKING INFORMATION
                                HStack {
                                    Image(systemName: "clock.fill").subtitleIcon()
                                    Text("Día y horario").subtitleGray()
                                }.padding(.top, 15)
                                Text(bookingSchedule.schedule).descriptionBlack()
                                
                                HStack {
                                    Image(systemName: "pin.fill").subtitleIcon()
                                    Text("Lugar").subtitleGray()
                                }.padding(.top, 15)
                                Text(bookingSchedule.place).descriptionBlack()
                                
                                HStack {
                                    Image(systemName: "house.fill").subtitleIcon()
                                    Text("Sector").subtitleGray()
                                }.padding(.top, 15)
                                Text(bookingSchedule.sector).descriptionBlack()
                                
                                // MARK: - IMAGE
                                if bookingSchedule.image == Constants.empty {
                                    Image(Constants.image).circleImage(width: 250, height: 250).padding(.top, 15)
                                } else {
                                    WebImage(url: URL(string: bookingSchedule.image)).placeholder { ProgressView() }
                                        .circleWebImage(width: 250, height: 250).padding(.top, 15)
                                }
                                
                                // MARK: - MORE BOOKING INFORMATION
                                HStack {
                                    Image(systemName: "person.3.fill").subtitleIcon()
                                    Text("Reserva para").subtitleGray()
                                }.padding(.top, 30)
                            }
                            
                            VStack {
                                Slider(
                                     value: $people,
                                     in: 1...Double(bookingSchedule.people),
                                     step: 1,
                                     onEditingChanged: { editing in
                                         isChoosingPeople = editing
                                     }
                                ).frame(width: UIScreen.main.bounds.width - 100)
                                if people == 1.0 {
                                    Text("1 persona").descriptionBlue(isChoosing: isChoosingPeople)
                                } else { Text("\(Int(people)) personas").descriptionBlue(isChoosing: isChoosingPeople) }
                                
                                HStack {
                                    Image(systemName: "person.crop.circle.fill").subtitleIcon()
                                    Text("A nombre de").subtitleGray()
                                }.padding(.top, 15)
                                Text(bookingSchedule.user).descriptionBlack()
                                
                                HStack {
                                    Image(systemName: "timer").subtitleIcon()
                                    Text("Tiempo de reserva").subtitleGray()
                                }.padding(.top, 15)
                                Text(bookingSchedule.limit).descriptionBlack()
                                
                                HStack {
                                    Image(systemName: "fork.knife").subtitleIcon()
                                    Text("Mesa (opcional)").subtitleGray()
                                }.padding(.top, 15)
                                if isBookingConfirmed {
                                    TextField("", text: $table).textFieldDisabled()
                                } else {
                                    TextField("", text: $table).textFieldEnabled().placeholder(when: table.isEmpty) {
                                        Text("Ingresá el número de mesa...").foregroundColor(.gray)
                                    }
                                }
                                
                                HStack {
                                    Image(systemName: "text.bubble").subtitleIcon()
                                    Text("Comentarios (opcional)").subtitleGray()
                                }.padding(.top, 15)
                                if isBookingConfirmed {
                                    TextField("", text: $comments).textFieldDisabled()
                                } else {
                                    TextField("", text: $comments).textFieldEnabled().placeholder(when: comments.isEmpty) {
                                        Text("Algo que quieras agregar...").foregroundColor(.gray)
                                    }
                                }
                            }
                            
                            // MARK: - BUTTONS
                            VStack {
                                Button {
                                    isScrollingTop.toggle()
                                    isBookingConfirmed = true
                                    table = table.isEmpty ? "Sin asignar todavía" : table
                                    comments = comments.isEmpty ? "No se agregaron" : comments
                                    let map = [
                                        "comments": comments,
                                        "date": bookingSchedule.date,
                                        "hour": bookingSchedule.hour,
                                        "limit": bookingSchedule.limit,
                                        "people": "\(people)".components(separatedBy: ".")[0],
                                        "rejection": Constants.empty,
                                        "sector": bookingSchedule.sector,
                                        "table": table
                                    ]
                                    bookingViewModel.updateBookings(map: map, userID: user.id, userPlace: user.place)
                                } label: {
                                    HStack {
                                        Image(systemName: "checkmark").imageButton()
                                        Text("CONFIRMAR RESERVA").textButton()
                                     }.frame(width: UIScreen.main.bounds.width - 100)
                                }.firstButton()
                                
                                Button {
                                    dismiss()
                                } label: {
                                    HStack {
                                        Image(systemName: "arrowshape.turn.up.left.fill").imageButton()
                                        Text("CERRAR").textButton()
                                     }.frame(width: UIScreen.main.bounds.width - 100)
                                }.lastButton()
                            }
                        }.padding()
                    }.grayStack()
                    .id(Constants.scroll)
                    .onChange(of: isScrollingTop, perform: { target in
                        withAnimation { scrollViewReader.scrollTo(Constants.scroll, anchor: .top) }
                    })
                }
            }
            
            // MARK: - DATA SOURCE RESPONSE
            if bookingViewModel.loadingUpdateBookings {
                CustomProgressView()
            } else {
                if bookingViewModel.successUpdateBookings == Constants.success {
                    CustomConfirmView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                bookingViewModel.successUpdateBookings = ""
                                bookingViewModel.getBookings(place: user.place, userID: user.id)
                                dismiss()
                            }
                        }
                }
                if !bookingViewModel.failureUpdateBookings.isEmpty {
                    CustomAlertView(description: bookingViewModel.failureUpdateBookings)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { isBookingConfirmed = false }
                        }
                }
            }
        }.blackStack()
    }
}

struct BookingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookingDetailView(viewModel: BookingViewModelImpl(bookingDataSource: BookingDataSourceImpl()), booking: BookingSchedule()).environmentObject(User())
    }
}
