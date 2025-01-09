//
//  EmployeeRowView.swift
//  Test
//
//  Created by Jatin Gupta on 09/01/25.
//

import SwiftUI

struct HomeScreenItemView: View {
    let employee: Employee
    let onCopy: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let name = employee.employeeName {
                    Text(name)
                        .font(.headline)
                }
                
                if let age = employee.employeeAge {
                    Text("Age: \(age)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let salary = employee.employeeSalary {
                    Text("Salary: $\(salary)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 5)
        .contextMenu {
            Button(action: onCopy) {
                Label("Copy", systemImage: "doc.on.doc")
            }
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}
