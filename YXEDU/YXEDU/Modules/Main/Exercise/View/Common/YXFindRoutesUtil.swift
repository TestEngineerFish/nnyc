//
//  FindRouteUtil.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/25.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

struct YXFindRouteUtil {

    // 矩阵是从0开始计算
    var itemNumberH: Int
    var itemNumberW: Int
    var blackList: [[Int]]
    var routeList  = [Int]()
    var wordLength = 0

    init(_ itemNumberH: Int, itemNumberW: Int) {
        self.itemNumberH = itemNumberH
        self.itemNumberW = itemNumberW
        blackList = Array(repeating: [Int](), count: itemNumberH * itemNumberW)
    }

    mutating func getRoute(start index: Int, wordLength: Int) -> [Int] {
        self.wordLength = wordLength
        self.findRoute(index)
        return self.routeList
    }

    mutating func findRoute(_ index: Int) {
        if !self.routeList.contains(index) {
            self.routeList.append(index)
//            print(self.routeList)
            // 如果找齐了,则直接返回
            if self.routeList.count >= self.wordLength {
                return
            }
        }
        // 获得有效数组
        var list = self.aroundIndexList(index)
        list = self.removeInvaildIndex(current: index, indexList: list)
        if list.isEmpty {
            // 1、先清空对应的黑名单列表
            self.blackList[index] = []
            // 2、移除路径的最后一个数
            let blackIndex = self.routeList.removeLast()
            guard let lastStep = self.routeList.last else {
                return
            }
            // 3、将其添加到黑名单中
            self.blackList[lastStep].append(blackIndex)
            // 4、使用上一个有效数组查找
            self.findRoute(lastStep)
        } else {
            for _ in list {
                // 如果找齐了,则跳出循环
                 if routeList.count >= wordLength {
                     break
                 }
                let nextIndex = Int.random(in: 0..<list.count)
                let nextStep  = list[nextIndex]
                self.findRoute(nextStep)
                list.remove(at: nextIndex)
            }
        }

    }

    // MARK: Tools

    /// 去除无效坐标
    private func removeInvaildIndex(current index: Int, indexList: [Int]) -> [Int] {
        let list = blackList[index]
        let validList = indexList.filter { (_index) -> Bool in
            return !routeList.contains(_index) && !list.contains(_index) // 并且黑名单也不包含
        }
        return validList
    }

    /// 返回周围的数字列表
    func aroundIndexList(_ num: Int) -> [Int] {
        var neighbours = [Int]()
        let left   = num - 1
        let right  = num + 1
        let top    = num - itemNumberW
        let bottom = num + itemNumberW
        let amount = itemNumberW * itemNumberH
        if left/itemNumberW == num/itemNumberW, left >= 0 {
            neighbours.append(left)
        }
        if right/itemNumberW == num/itemNumberW, right < amount {
            neighbours.append(right)
        }
        if top >= 0 {
            neighbours.append(top)
        }
        if bottom < amount{
            neighbours.append(bottom)
        }
        return neighbours
    }

}
