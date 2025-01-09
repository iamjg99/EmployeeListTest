//
//  HomeScreenViewModel.swift
//  Test
//
//  Created by Jatin Gupta on 09/01/25.
//

import SwiftUI
import Combine

class HomeScreenViewModel: ObservableObject {
    @Published var employees: [Employee] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let urlString = "https://a00407a8-f46e-407e-b684-5d949532e7fc.mock.pstmn.io/api/v1/employees"

    func fetchEmployees() {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        errorMessage = nil

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: EmployeeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] response in
                guard let data = response.data else { return }
                self?.employees = data
            })
            .store(in: &cancellables)
    }

    func copyEmployee(_ employee: Employee) {
        let newEmployee = Employee(
            id: (employees.last?.id ?? 0) + 1,
            employeeName: employee.employeeName,
            employeeSalary: employee.employeeSalary,
            employeeAge: employee.employeeAge,
            profileImage: employee.profileImage
        )
        employees.append(newEmployee)
    }

    func deleteEmployee(_ employee: Employee) {
        employees.removeAll { $0.id == employee.id }
    }
}
