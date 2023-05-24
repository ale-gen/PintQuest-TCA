//
//  FavClient.swift
//  PintQuest-TCA
//
//  Created by Aleksandra Generowicz on 22/05/2023.
//

import ComposableArchitecture
import Foundation

struct FavClient {
    var all: @Sendable () async throws -> [Beer]
    var add: @Sendable (Int) async throws -> [Beer]
    var remove: @Sendable (Int) async throws -> [Beer]
    
    private static let key: String = "FavIds"
    private static let userDefaults = UserDefaults.standard
}

extension FavClient {
    
    private static func add(_ newBeerId: Int) {
        var favIds = getAll()
        favIds.append(newBeerId)
        save(favIds)
    }
    
    private static func remove(_ beerId: Int) {
        let favIds = getAll().filter { $0 != beerId }
        save(favIds)
    }
    
    private static func getAll() -> [Int] {
        return userDefaults.object(forKey: key) as? [Int] ?? []
    }
    
    private static func save(_ ids: [Int]) {
        userDefaults.set(ids, forKey: key)
    }
}

extension DependencyValues {
    var favClient: FavClient {
        get { self[FavClient.self] }
        set { self[FavClient.self] = newValue }
    }
}

extension FavClient: DependencyKey {
    /// This is the "live" fact dependency that reaches into the outside world to fetch trivia.
    /// Typically this live implementation of the dependency would live in its own module so that the
    /// main feature doesn't need to compile it.
    static let liveValue = Self(
        all: {
            guard let url = Router.fetchBeersByIds(getAll()).url else { return [] }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Beer].self, from: data)
        },
        add: { beerId in
            add(beerId)
            guard let url = Router.fetchBeersByIds(getAll()).url else { return [] }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Beer].self, from: data)
        },
        remove: { beerId in
            remove(beerId)
            guard let url = Router.fetchBeersByIds(getAll()).url else { return [] }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode([Beer].self, from: data)
        }
    )
    
    /// This is the "unimplemented" fact dependency that is useful to plug into tests that you want
    /// to prove do not need the dependency.
    static let testValue = Self(
        all: unimplemented("\(Self.self).all"),
        add: unimplemented("\(Self.self).add"),
        remove: unimplemented("\(Self.self).remove")
    )
}
