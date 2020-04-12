//
//  ActionCell.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

// Extend CellConfigurable version buy protocol composition
public protocol ActionCell: ConfigurableCell, CellActionable { }
