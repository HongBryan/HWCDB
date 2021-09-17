//
//  HKStatementUpdateSQL.swift
//  HKAtHome
//
//  Created by Bryan on 2021/7/27.
//  Copyright © 2021 HomeKing. All rights reserved.
//

import Foundation

public final class HKStatementUpdateSQL: Statement {
    public private(set) var description: String = ""
    public var statementType: StatementType {
        return .update
    }

    public init(sql: String) {
        self.description = sql
    }
}
