//
//  BookingView.swift
//  MorfiTimeLocal
//
//  Created by Marcos Vitureira on 27/09/2021.
//

import SwiftUI

struct BookingView: View {
    
    // MARK: - VIEW MODEL
    @ObservedObject private var bookingViewModel: BookingViewModelImpl
    
    // MARK: - BOOLEANS
    @State private var isShowingAnimation = true
    @State private var isTouchingDays = false
    @State private var isShowingDays = false
    @State private var isShowingSchedule = false
    @State private var isStartingDetail = false
    
    // MARK: - VARIABLES
    @EnvironmentObject private var user: User
    @State private var sectorPicked = BookingSector()
    @State private var dayPicked = ""
    @State private var schedulePicked = BookingSchedule()
    
    init(viewModel: BookingViewModelImpl, userData: User) {
        bookingViewModel = viewModel
        bookingViewModel.getBookings(place: userData.place, userID: userData.id)
    }
    
    var body: some View {
        ZStack {
            if bookingViewModel.successGetBookings.days.isEmpty {
                CustomProgressView()
            } else {
                ScrollView {
                    ScrollViewReader { scrollViewReader in
                        VStack(alignment: .leading) {
                            
                            // MARK: - PICK SECTOR
                            VStack(alignment: .leading) {
                                Text("Elegí un sector del lugar").titleWhite()
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(bookingViewModel.successGetBookings.sectors, id: \.self) { sector in
                                            Button(action: {
                                                isShowingDays = true
                                                isShowingSchedule = false
                                                sectorPicked = sector
                                            }) { BookingSectorRowView(bookingSector: sector) }
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 50)
                            
                            // MARK: - PICK DAY
                            if isShowingDays {
                                VStack(alignment: .leading) {
                                    Text("Ahora, elegí un día para \(sectorPicked.name)").titleWhite()
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(bookingViewModel.successGetBookings.days, id: \.self) { day in
                                                Button(action: {
                                                    isTouchingDays = true
                                                    isShowingSchedule = true
                                                    dayPicked = day
                                                }) { BookingDaysRowView(bookingDays: day) }
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 50)
                            }
                            
                            // MARK: - PICK SCHEDULE
                            if isShowingSchedule {
                                VStack(alignment: .leading) {
                                    Text("Por último, elegí un horario").titleWhite()
                                    ZStack {
                                        VStack {
                                            ScrollView {
                                                ForEach(bookingViewModel.successGetBookings.schedule, id: \.self) { schedule in
                                                    if schedule.schedule.contains(dayPicked) && schedule.sector.contains(sectorPicked.sector) {
                                                        Button(action: {
                                                            isStartingDetail = true
                                                            schedulePicked = schedule
                                                        }) { BookingScheduleRowView(bookingSchedule: schedule) }
                                                    }
                                                }
                                            }
                                        }
                                        .frame(height: 300, alignment: .topLeading)
                                    }
                                    .background(Constants.grayLight)
                                    .cornerRadius(10)
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        .padding()
                        .id(Constants.scroll)
                        .onChange(of: isTouchingDays, perform: { target in
                            withAnimation { scrollViewReader.scrollTo(Constants.scroll, anchor: .bottomTrailing) }
                        })
                        .onAppear {
                            isShowingDays = false
                            isShowingSchedule = false
                            isShowingAnimation = true
                            bookingViewModel.getBookings(place: user.place, userID: user.id)
                            withAnimation(.easeOut(duration: 0.3)) { isShowingAnimation = false }
                        }
                        .onDisappear {
                            isTouchingDays = false
                            bookingViewModel.removeListener()
                        }
                        .opacity(isShowingAnimation ? 0 : 1)
                    }
                }
            }
            
            // MARK: - DATA SOURCE RESPONSE
            if !bookingViewModel.failureGetBookings.isEmpty {
                CustomAlertView(description: bookingViewModel.failureGetBookings)
            }
            
            // MARK: - NAVIGATION DETAIL
            NavigationLink(isActive: $isStartingDetail) {
                BookingDetailView(viewModel: bookingViewModel, booking: schedulePicked)
            } label: { EmptyView() }.isDetailLink(false)
            
        }
        .blackStack()
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView(viewModel: BookingViewModelImpl(bookingDataSource: BookingDataSourceImpl()), userData: User()).environmentObject(User())
    }
}
