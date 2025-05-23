//
//  TierType.swift
//  WordPalette
//
//  Created by Quarang on 5/22/25.
//

import UIKit

// MARK: 티어표
enum TierType: String, CaseIterable {
    case bronzeIV = "브론즈 IV"
    case bronzeIII = "브론즈 III"
    case bronzeII = "브론즈 II"
    case bronzeI = "브론즈 I"
    case silverIV = "실버 IV"
    case silverIII = "실버 III"
    case silverII = "실버 II"
    case silverI = "실버 I"
    case goldIV = "골드 IV"
    case goldIII = "골드 III"
    case goldII = "골드 II"
    case goldI = "골드 I"
    case masterIV = "마스터 IV"
    case masterIII = "마스터 III"
    case masterII = "마스터 II"
    case masterI = "마스터 I"
    
    /// 점수 기반 티어 초기화
    init?(value: Int) {
        guard let tier = TierType.allCases.first(where: { $0.scoreRange.contains(value) }) else {
            return nil
        }
        self = tier
    }
    
    /// 티어 점수 범위 반환
    var scoreRange: Range<Int> {
        switch self {
        case .bronzeIV: return 0..<21
        case .bronzeIII: return 21..<41
        case .bronzeII: return 41..<61
        case .bronzeI: return 61..<81
        case .silverIV: return 81..<101
        case .silverIII: return 101..<131
        case .silverII: return 131..<161
        case .silverI: return 161..<191
        case .goldIV: return 191..<231
        case .goldIII: return 231..<271
        case .goldII: return 271..<311
        case .goldI: return 311..<351
        case .masterIV: return 351..<401
        case .masterIII: return 401..<461
        case .masterII: return 461..<521
        case .masterI: return 521..<Int.max
        }
    }
    
    /// 다음 티어 반환 (마지막 티어면 nil)
    var nextTier: TierType? {
        let all = Self.allCases
        guard let currentIndex = all.firstIndex(of: self),
              currentIndex + 1 < all.count else {
            return nil
        }
        return all[currentIndex + 1]
    }
    
    /// 표시할 이모지
    var emoji: String {
        switch self {
        case .bronzeIV, .bronzeIII, .bronzeII, .bronzeI:
            return "🥉"
        case .silverIV, .silverIII, .silverII, .silverI:
            return "🥈"
        case .goldIV, .goldIII, .goldII, .goldI:
            return "🥇"
        case .masterIV, .masterIII, .masterII, .masterI:
            return "🎖️"
        }
    }

    
    /// 배경 색상
    var backgroundColor: UIColor {
        switch self {
        case .bronzeIV, .bronzeIII, .bronzeII, .bronzeI:
            return .brown.withAlphaComponent(0.5)
        case .silverIV, .silverIII, .silverII, .silverI:
            return .gray.withAlphaComponent(0.7)
        case .goldIV, .goldIII, .goldII, .goldI:
            return .customMango.withAlphaComponent(0.8)
        case .masterIV, .masterIII, .masterII, .masterI:
            return .customStrawBerry.withAlphaComponent(0.6)
        }
    }
}
