//
//  HKUpdateSQL.swift
//  HKAtHome
//
//  Created by Bryan on 2021/7/27.
//  Copyright © 2021 HomeKing. All rights reserved.
//

import Foundation
extension Database {
    public func prepareUpdateSQL(sql: String) throws -> HKUpdateSQL {
        return try HKUpdateSQL(with: self, sql: sql)
    }

    public func prepareUpdateSQL(sql: String, values: [ColumnEncodableBase]?) throws -> HKUpdateSQL {
        return try HKUpdateSQL(with: self, sql: sql, values: values)
    }
}

/// The chain call for updating
public final class HKUpdateSQL {
    private var core: Core
    private let statement: HKStatementUpdateSQL
    private var values: [ColumnEncodableBase]?

    /// The number of changed rows in the most recent call.
    /// It should be called after executing successfully
    public var changes: Int?

    init(with core: Core, sql: String) throws {
        self.core = core
        self.statement = HKStatementUpdateSQL(sql: sql)
    }
    
    init(with core: Core, sql: String, values: [ColumnEncodableBase]?) throws {
        self.core = core
        self.statement = HKStatementUpdateSQL(sql: sql)
        self.values = values
    }

    /// Execute the update chain call with row.
    ///
    /// - Parameter row: Column encodable row
    /// - Throws: `Error`
    public func execute(with row: [ColumnEncodableBase?] = []) throws {
        let recyclableHandleStatement: RecyclableHandleStatement = try core.prepare(statement)
        let handleStatement = recyclableHandleStatement.raw
        for (index, value) in row.enumerated() {
            let bindingIndex = index + 1
            handleStatement.bind(value?.archivedFundamentalValue(), toIndex: bindingIndex)
        }
        if values != nil {
            for index in 0..<values!.count {
                let bindingIndex = index + 1
                let value = values?[index]
                handleStatement.bind(value?.archivedFundamentalValue(), toIndex: bindingIndex)
            }
        }
        try handleStatement.step()
        changes = handleStatement.changes
    }
}

extension HKUpdateSQL: CoreRepresentable {

    /// The tag of the related database.
    public var tag: Tag? {
        return core.tag
    }

    /// The path of the related database.
    public var path: String {
        return core.path
    }
}
