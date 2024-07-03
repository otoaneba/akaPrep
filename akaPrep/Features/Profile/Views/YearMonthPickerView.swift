//
//  YearMonthPickerView.swift
//  akaPrep
//
//  Created by Naoto Abe on 7/2/24.
//

import SwiftUI

struct YearMonthPickerView: View {
    @Binding var selectedDate: Date
    
    let months: [String] = Calendar.current.shortMonthSymbols
    let columns = [
        GridItem(.adaptive(minimum: 80))
    ]
    
    var body: some View {
        VStack {
            //year picker
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 24.0)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.year = -1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                        print(selectedDate)
                    }
                
                Text(String(selectedDate.year()))
                         .fontWeight(.bold)
                         .transition(.move(edge: .trailing))
                
                Image(systemName: "chevron.right")
                    .frame(width: 24.0)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.year = 1
                        selectedDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate)!
                        print(selectedDate)
                    }
            }.padding(15)
            
            //month picker
            LazyVGrid(columns: columns, spacing: 20) {
               ForEach(months, id: \.self) { item in
                    Text(item)
                    .font(.headline)
                    .frame(width: 60, height: 33)
                    .bold()
                    .foregroundColor(item == selectedDate.monthName().prefix(3) ? Color.red : Color.primary)
                    .cornerRadius(8)
                    .onTapGesture {
                        var dateComponent = DateComponents()
                        dateComponent.day = 2
                        dateComponent.month =  months.firstIndex(of: item)! + 1
                        dateComponent.year = selectedDate.year()
                        selectedDate = Calendar.current.date(from: dateComponent) ?? selectedDate
                        print(selectedDate)
    
                    }
               }
            }
            .padding(.horizontal)
        }
    }
}

extension Date {
    func year() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    func monthName() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        return calendar.monthSymbols[month - 1]
    }
}

struct YearMonthPickerView_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthPickerView(selectedDate: .constant(Date()))
    }
}
