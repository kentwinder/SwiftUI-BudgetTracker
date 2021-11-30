//
//  BudgetListView.swift
//  BudgetTracker
//
//  Created by Kent Winder on 2/15/21.
//

import SwiftUI
import Combine
import WidgetKit

struct BudgetListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Budget.updatedAt, ascending: false)])
    private var items: FetchedResults<Budget>
    // private var viewModel = BudgetListViewModel()
    
    @State private var selectedItem: Budget?
    // Because when we update any item (except the first one), the sort order will change
    // causing the identity of the pushed DetailsView > it will pop automatically when you click save
    @State private var isActive = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        NavigationView {
            LinearGradient(gradient: Gradient(colors: [Color.nileBlue, Color.dullBlue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.vertical)
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        NavigationLink(
                            destination: BudgetDetailsView().environmentObject(BudgetDetailsViewModel(budget: selectedItem, isActive: $isActive)),
                            isActive: self.$isActive) {
                                EmptyView()
                            }
                        
                        Text("\(items.map({$0.amount?.intValue ?? 0}).reduce(0, +))")
                            .font(.system(size: 70.0, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.feta)
                            .padding()
                        
                        List {
                            ForEach(items) { item in
                                Button(action: {
                                    self.selectedItem = item
                                    self.isActive = true
                                }) {
                                    HStack {
                                        Text(item.details ?? "").foregroundColor(Color.feta)
                                        Spacer()
                                        Text("\(item.amount ?? 0)")
                                            .foregroundColor(item.isIncome() ? Color.aquaIsland : Color.amaranth)
                                            .font(.headline)
                                    }
                                }
                            }.onDelete(perform: deleteItems)
                                .listRowBackground(Color.clear)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.selectedItem = nil
                                    self.isActive = true
                                }) {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 28.0, height: 28.0)
                                        .foregroundColor(Color.aquaIsland)
                                }
                                Spacer()
                            }.padding()
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }.listStyle(PlainListStyle())
                    }
                ).navigationBarHidden(true)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
                WidgetCenter.shared.reloadTimelines(ofKind: "BudgetTracker_Widget")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
    }
}

