//
//  PunkAPIClient.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 07/05/2023.
//

import ComposableArchitecture
import Foundation

struct PunkAPIClient {
    var fetchByPage: @Sendable (Int) async throws -> [Beer]
    var fetchByName: @Sendable (String, Int) async throws -> [Beer]
}

extension DependencyValues {
    var punkAPIClient: PunkAPIClient {
        get { self[PunkAPIClient.self] }
        set { self[PunkAPIClient.self] = newValue }
    }
}

extension PunkAPIClient: DependencyKey {
    /// This is the "live" fact dependency that reaches into the outside world to fetch trivia.
    /// Typically this live implementation of the dependency would live in its own module so that the
    /// main feature doesn't need to compile it.
    static let liveValue = Self(
        fetchByPage: { page in
            guard let url = Router.beersPage(page).url else { return [] }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Beer].self, from: data)
        },
        fetchByName: { name, page in
            guard let url = Router.nameBeersPage(name, page).url else { return [] }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Beer].self, from: data)
        }
    )
    
    /// This is the "unimplemented" fact dependency that is useful to plug into tests that you want
    /// to prove do not need the dependency.
    static let testValue = Self(
        fetchByPage: unimplemented("\(Self.self).fetchByPage"),
        fetchByName: unimplemented("\(Self.self).fetchByName")
    )
}
