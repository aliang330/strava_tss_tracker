//
//  SQLiteSwift.swift
//  StravaActivityGetter
//
//  Created by Allen on 5/31/20.
//  Copyright © 2020 Allen. All rights reserved.
//

import Foundation
import SQLite3

public let DATABASE_PATH = FileManager.documentDirectoryURL.appendingPathComponent("database.sqlite").relativePath

enum SQLiteError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
    case Bind(message: String)
}

class SQLiteDatabase {
    private let dbPointer: OpaquePointer?
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    
    fileprivate var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer?
        // 1
        if sqlite3_open(path, &db) == SQLITE_OK {
            // 2
            return SQLiteDatabase(dbPointer: db)
        } else {
            // 3
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError
                    .OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    func createTable(table: SQLTable.Type) throws {
        // 1
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        // 2
        defer {
            sqlite3_finalize(createTableStatement)
        }
        // 3
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table created.")
    }
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil)
            == SQLITE_OK else {
                throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
    
    func insertActivity(activity: Activity) throws {
        let insertSql = "INSERT INTO Activity (Id, Name, ElapsedTime, Distance) VALUES (?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let name = NSString(string: activity.name).utf8String
        let id = Int64(activity.id)
        let timeElapsed = Int32(activity.elapsed_time)
        let distance = activity.distance
        
        guard
            sqlite3_bind_int64(insertStatement, 1, id) == SQLITE_OK  &&
                sqlite3_bind_text(insertStatement, 2, name, -1, nil) == SQLITE_OK &&
                sqlite3_bind_int(insertStatement, 3, timeElapsed) == SQLITE_OK &&
                sqlite3_bind_double(insertStatement, 4, distance) == SQLITE_OK
            else {
                throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted row.")
    }
    
    func getActivity(id: Int64) -> Activity? {
      let querySql = "SELECT * FROM Activity WHERE Id = ?;"
      guard let queryStatement = try? prepareStatement(sql: querySql) else {
        return nil
      }
      defer {
        sqlite3_finalize(queryStatement)
      }
      guard sqlite3_bind_int64(queryStatement, 1, id) == SQLITE_OK else {
        return nil
      }
      guard sqlite3_step(queryStatement) == SQLITE_ROW else {
        return nil
      }
      let id = sqlite3_column_int(queryStatement, 0)
      guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
        print("Query result is nil.")
        return nil
      }
      let name = String(cString: queryResultCol1) as NSString
      let activity = Activity()
        activity.id = Int(id)
        activity.name = String(name)
        return activity
    }
    
    func deleteTable(deleteStatementString: String) {
        var deleteStatement: OpaquePointer?
        do {
            deleteStatement = try prepareStatement(sql: deleteStatementString)
        } catch {
            print("error preparing statement. ", error)
        }
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            print("\nTable deleted.")
        } else {
            print("\nError deleting table.")
        }
    }
    
}

struct Contact {
    let id: Int32
    let name: NSString
}

protocol SQLTable {
    static var createStatement: String { get }
}

extension Contact: SQLTable {
    static var createStatement: String {
        return """
        CREATE TABLE Contact(
        Id INT PRIMARY KEY NOT NULL,
        Name CHAR(255)
        );
        """
    }
}
