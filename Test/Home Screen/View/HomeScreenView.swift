//
//  HomeScreenView.swift
//  Test
//
//  Created by Jatin Gupta on 09/01/25.
//

import SwiftUI

struct HomeScreenView: View {
    @StateObject private var viewModel = HomeScreenViewModel()
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var shouldScrollToBottom: Bool = false
    @State private var isCopyAction: Bool = false
    @State private var deletingEmployeeID: Int? = nil
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollViewReader { proxy in
                    Group {
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                        } else if let errorMessage = viewModel.errorMessage {
                            ErrorView(errorMessage: errorMessage) {
                                viewModel.fetchEmployees()
                            }
                        } else {
                            List {
                                ForEach(viewModel.employees) { employee in
                                    ZStack {
                                        if deletingEmployeeID == employee.id {
                                            BurstFadeAnimation()
                                                .frame(height: 150)
                                                .onAppear {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                        viewModel.deleteEmployee(employee)
                                                        deletingEmployeeID = nil
                                                    }
                                                }
                                        } else {
                                            HomeScreenItemView(
                                                employee: employee,
                                                onCopy: {
                                                    viewModel.copyEmployee(employee)
                                                    if let copiedName = employee.employeeName {
                                                        showToastWithMessage("Copied \(copiedName)!", isCopy: true)
                                                    }
                                                },
                                                onDelete: {
                                                    deletingEmployeeID = employee.id
                                                    if let deletedName = employee.employeeName {
                                                        showToastWithMessage("Deleted \(deletedName).", isCopy: false)
                                                    }
                                                }
                                            )
                                            .id(employee.id)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .navigationTitle("Employees")
                    .onAppear {
                        viewModel.fetchEmployees()
                    }
                    .onChange(of: shouldScrollToBottom) { newValue in
                        if newValue, let lastID = viewModel.employees.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastID, anchor: .bottom)
                            }
                            shouldScrollToBottom = false
                        }
                    }
                }
            }

            if showToast {
                VStack {
                    Spacer()
                    ToastView(
                        message: toastMessage,
                        onScrollToBottom: isCopyAction ? {
                            shouldScrollToBottom = true
                            withAnimation {
                                showToast = false
                            }
                        } : nil
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private func showToastWithMessage(_ message: String, isCopy: Bool) {
        toastMessage = message
        isCopyAction = isCopy
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                showToast = false
            }
        }
    }
}

#Preview {
    HomeScreenView()
}
