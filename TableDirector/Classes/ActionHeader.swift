//
//  ActionHeader.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 01.05.2020.
//

import Foundation

public protocol ActionHeader: ConfigurableHeaderFooter, TableItemActionable { }

public typealias ActionFooter = ActionHeader
