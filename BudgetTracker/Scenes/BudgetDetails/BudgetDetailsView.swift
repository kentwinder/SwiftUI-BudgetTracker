//
//  BudgetDetailsView.swift
//  BudgetTracker
//
//  Created by Kent Winder on 2/22/21.
//

import SwiftUI

struct BudgetDetailsView: View {
    @EnvironmentObject var viewModel: BudgetDetailsViewModel
    
    var body: some View {
        VStack {
            TextField("Details", text: $viewModel.details)
                .padding()
            Divider()
            TextField("Amount", text: $viewModel.amount)
                .keyboardType(.numberPad)
                .padding()
            Divider()
            HStack {
                Text("Income").padding()
                Spacer()
                Toggle("", isOn: $viewModel.isIncome)
            }
            Divider()
            Text(viewModel.errorMessage).foregroundColor(Color.red)
            Spacer()
        }.padding()
        .navigationBarTitle("Details", displayMode: .automatic)
        .navigationBarItems(trailing: Button("Save", action: viewModel.save))
    }
}

struct BudgetDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetDetailsView()
    }
}
