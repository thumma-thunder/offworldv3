//
//  DatabaseHelper.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import Foundation
import SQLite3

let SQLITE_TRANSIENT = unsafeBitCast(-1, to: (@convention(c) (UnsafeMutableRawPointer?) -> Void).self)

/// Centralised wrapper around the raw SQLite3 APIs that we use throughout the app.
///
/// The helper is responsible for:
///  - opening the OffWorld database inside the application's documents directory
///  - ensuring that the tables required by the app exist
///  - providing convenience helpers for the common queries we run from the UI layer
final class DatabaseHelper {

    // MARK: Shared instance

    static let shared = DatabaseHelper()

    // MARK: Private properties

    private let databaseName = "OffWorldUsers.sqlite"
    private var db: OpaquePointer?

    private init() {
        openDatabase()
        createTablesIfNeeded()
    }

    deinit {
        if let db {
            sqlite3_close(db)
        }
    }

    // MARK: Database bootstrap

    private func openDatabase() {
        guard db == nil else { return }

        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(databaseName)

            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                let message = db.flatMap { sqlite3_errmsg($0) }.map { String(cString: $0) } ?? "Unknown error"
                print("❌ Unable to open database: \(message)")
            } else {
                print("✅ Database ready at \(fileURL.path)")
            }
        } catch {
            print("❌ Unable to resolve database location: \(error.localizedDescription)")
        }
    }

    private func createTablesIfNeeded() {
        guard let db else { return }

        let createUsers = """
        CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL,
            password TEXT NOT NULL,
            accountType TEXT NOT NULL,
            zipcode TEXT NOT NULL
        );
        """

        let createCompanies = """
        CREATE TABLE IF NOT EXISTS Companies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            website TEXT,
            category TEXT,
            created_at TEXT DEFAULT (datetime('now'))
        );
        """

        [createUsers, createCompanies].forEach { query in
            if sqlite3_exec(db, query, nil, nil, nil) != SQLITE_OK {
                if let errorMessage = sqlite3_errmsg(db) {
                    print("❌ Table creation failed: \(String(cString: errorMessage))")
                }
            }
        }
    }

    // MARK: Public helpers

    func createUser(username: String, email: String, password: String, accountType: String, zipcode: String) -> Bool {
        guard let db else { return false }

        let query = "INSERT INTO Users (username, email, password, accountType, zipcode) VALUES (?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            logPreparationError()
            return false
        }

        sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 3, (password as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 4, (accountType as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 5, (zipcode as NSString).utf8String, -1, SQLITE_TRANSIENT)

        if sqlite3_step(statement) == SQLITE_DONE {
            return true
        } else {
            logExecutionError()
            return false
        }
    }

    func validateUser(email: String, password: String) -> Bool {
        userAccountType(email: email, password: password) != nil
    }

    func userAccountType(email: String, password: String) -> String? {
        guard let db else { return nil }

        let query = "SELECT accountType FROM Users WHERE email = ? AND password = ? LIMIT 1;"
        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            logPreparationError()
            return nil
        }

        sqlite3_bind_text(statement, 1, (email as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, SQLITE_TRANSIENT)

        if sqlite3_step(statement) == SQLITE_ROW {
            return stringFromColumn(statement, index: 0)
        }

        return nil
    }

    func insertCompany(name: String, description: String, website: String, category: String) -> Bool {
        guard let db else { return false }

        let query = "INSERT INTO Companies (name, description, website, category) VALUES (?, ?, ?, ?);"
        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            logPreparationError()
            return false
        }

        sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 2, (description as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 3, (website as NSString).utf8String, -1, SQLITE_TRANSIENT)
        sqlite3_bind_text(statement, 4, (category as NSString).utf8String, -1, SQLITE_TRANSIENT)

        if sqlite3_step(statement) == SQLITE_DONE {
            return true
        } else {
            logExecutionError()
            return false
        }
    }

    func fetchCompanies() -> [Company] {
        guard let db else { return [] }

        let query = "SELECT name, description, category, website, created_at FROM Companies ORDER BY datetime(created_at) DESC;"
        var statement: OpaquePointer?
        var companies: [Company] = []
        defer { sqlite3_finalize(statement) }

        guard sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK else {
            logPreparationError()
            return []
        }

        while sqlite3_step(statement) == SQLITE_ROW {
            let name = stringFromColumn(statement, index: 0)
            let description = stringFromColumn(statement, index: 1)
            let category = stringFromColumn(statement, index: 2)
            let website = stringFromColumn(statement, index: 3)
            let createdAt = stringFromColumn(statement, index: 4)

            companies.append(Company(name: name,
                                     description: description,
                                     category: category,
                                     website: website,
                                     createdAt: createdAt))
        }

        return companies
    }

    // MARK: Helpers

    private func stringFromColumn(_ statement: OpaquePointer?, index: Int32) -> String {
        guard let textPointer = sqlite3_column_text(statement, index) else { return "" }
        return String(cString: textPointer)
    }

    private func logPreparationError() {
        guard let db, let errorPointer = sqlite3_errmsg(db) else { return }
        print("❌ Failed to prepare statement: \(String(cString: errorPointer))")
    }

    private func logExecutionError() {
        guard let db, let errorPointer = sqlite3_errmsg(db) else { return }
        print("❌ Statement execution failed: \(String(cString: errorPointer))")
    }
}

// MARK: - Models

struct Company {
    let name: String
    let description: String
    let category: String
    let website: String
    let createdAt: String
}
