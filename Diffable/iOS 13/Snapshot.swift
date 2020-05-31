//
//  Snapshot.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 31.05.2020.
//

import Foundation

protocol Snapshot { }

@available(iOS 13.0, *)
extension NSDiffableDataSourceSnapshot: Snapshot { }
