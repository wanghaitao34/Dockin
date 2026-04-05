//
//  DockinLocalization.swift
//  Dockin
//
//  Created by Codex on 5/4/26.
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case chinese = "zh-Hans"
    case english = "en"
    case japanese = "ja"
    case korean = "ko"
    case spanish = "es"
    case french = "fr"

    var id: String { rawValue }

    var nativeName: String {
        switch self {
        case .system:
            "System"
        case .chinese:
            "中文"
        case .english:
            "English"
        case .japanese:
            "日本語"
        case .korean:
            "한국어"
        case .spanish:
            "Español"
        case .french:
            "Français"
        }
    }

    static func preferredDefault() -> AppLanguage {
        for identifier in Locale.preferredLanguages {
            if identifier.hasPrefix("zh") { return .chinese }
            if identifier.hasPrefix("ja") { return .japanese }
            if identifier.hasPrefix("ko") { return .korean }
            if identifier.hasPrefix("es") { return .spanish }
            if identifier.hasPrefix("fr") { return .french }
            if identifier.hasPrefix("en") { return .english }
        }

        return .english
    }
}

enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            nil
        case .light:
            .light
        case .dark:
            .dark
        }
    }
}

struct DockinStrings {
    let language: AppLanguage

    private var resolvedLanguage: AppLanguage {
        language == .system ? .preferredDefault() : language
    }

    var appName: String { "Dockin" }

    var statusProtecting: String {
        translate(
            zh: "保护中",
            en: "Protecting",
            ja: "保護中",
            ko: "보호 중",
            es: "Protegiendo",
            fr: "Protection active"
        )
    }

    var statusOff: String {
        translate(
            zh: "已关闭",
            en: "Off",
            ja: "オフ",
            ko: "꺼짐",
            es: "Desactivado",
            fr: "Désactivé"
        )
    }

    var statusPaused: String {
        translate(
            zh: "已暂停",
            en: "Paused",
            ja: "一時停止",
            ko: "일시 정지",
            es: "En pausa",
            fr: "En pause"
        )
    }

    var enableDockLock: String {
        translate(
            zh: "启用 Dock 固定",
            en: "Enable Dock Lock",
            ja: "Dock固定を有効にする",
            ko: "Dock 고정 사용",
            es: "Activar bloqueo del Dock",
            fr: "Activer le verrouillage du Dock"
        )
    }

    var targetDisplay: String {
        translate(
            zh: "目标显示器",
            en: "Target Display",
            ja: "対象ディスプレイ",
            ko: "대상 디스플레이",
            es: "Pantalla objetivo",
            fr: "Écran cible"
        )
    }

    var edgeBounceDistance: String {
        translate(
            zh: "边缘回弹距离",
            en: "Edge Bounce Distance",
            ja: "端の跳ね返し距離",
            ko: "가장자리 반동 거리",
            es: "Distancia de rebote del borde",
            fr: "Distance de rebond au bord"
        )
    }

    var currentDockPosition: String {
        translate(
            zh: "当前 Dock 位置",
            en: "Current Dock Position",
            ja: "現在のDock位置",
            ko: "현재 Dock 위치",
            es: "Posición actual del Dock",
            fr: "Position actuelle du Dock"
        )
    }

    func connectedDisplays(_ count: Int) -> String {
        switch resolvedLanguage {
        case .system:
            "Connected Displays (\(count))"
        case .chinese:
            "已连接显示器 (\(count))"
        case .english:
            "Connected Displays (\(count))"
        case .japanese:
            "接続中のディスプレイ (\(count))"
        case .korean:
            "연결된 디스플레이 (\(count))"
        case .spanish:
            "Pantallas conectadas (\(count))"
        case .french:
            "Écrans connectés (\(count))"
        }
    }

    var noDisplaysDetected: String {
        translate(
            zh: "未检测到显示器",
            en: "No displays detected",
            ja: "ディスプレイが見つかりません",
            ko: "디스플레이를 찾을 수 없음",
            es: "No se detectaron pantallas",
            fr: "Aucun écran détecté"
        )
    }

    var refreshDisplays: String {
        translate(
            zh: "刷新显示器",
            en: "Refresh Displays",
            ja: "ディスプレイを再読み込み",
            ko: "디스플레이 새로 고침",
            es: "Actualizar pantallas",
            fr: "Actualiser les écrans"
        )
    }

    var quitApp: String {
        translate(
            zh: "退出 Dockin",
            en: "Quit Dockin",
            ja: "Dockinを終了",
            ko: "Dockin 종료",
            es: "Salir de Dockin",
            fr: "Quitter Dockin"
        )
    }

    var settings: String {
        translate(
            zh: "设置",
            en: "Settings",
            ja: "設定",
            ko: "설정",
            es: "Ajustes",
            fr: "Réglages"
        )
    }

    var languageTitle: String {
        translate(
            zh: "语言",
            en: "Language",
            ja: "言語",
            ko: "언어",
            es: "Idioma",
            fr: "Langue"
        )
    }

    var launchAtLogin: String {
        translate(
            zh: "开机自动启动",
            en: "Launch at Login",
            ja: "ログイン時に起動",
            ko: "로그인 시 자동 실행",
            es: "Iniciar al abrir sesión",
            fr: "Lancer à l’ouverture de session"
        )
    }

    var appearance: String {
        translate(
            zh: "外观模式",
            en: "Appearance",
            ja: "外観モード",
            ko: "모양",
            es: "Apariencia",
            fr: "Apparence"
        )
    }

    var followSystem: String {
        translate(
            zh: "跟随系统",
            en: "Follow System",
            ja: "システムに従う",
            ko: "시스템 따르기",
            es: "Seguir al sistema",
            fr: "Suivre le système"
        )
    }

    var light: String {
        translate(
            zh: "亮色",
            en: "Light",
            ja: "ライト",
            ko: "라이트",
            es: "Claro",
            fr: "Clair"
        )
    }

    var dark: String {
        translate(
            zh: "暗色",
            en: "Dark",
            ja: "ダーク",
            ko: "다크",
            es: "Oscuro",
            fr: "Sombre"
        )
    }

    var dockPinned: String {
        translate(
            zh: "Dock 固定",
            en: "Dock Locked",
            ja: "Dock固定",
            ko: "Dock 고정",
            es: "Dock fijado",
            fr: "Dock verrouillé"
        )
    }

    var blocked: String {
        translate(
            zh: "已屏蔽",
            en: "Blocked",
            ja: "ブロック済み",
            ko: "차단됨",
            es: "Bloqueada",
            fr: "Bloqué"
        )
    }

    var mainDisplay: String {
        translate(
            zh: "主显示器",
            en: "Main Display",
            ja: "メインディスプレイ",
            ko: "주 디스플레이",
            es: "Pantalla principal",
            fr: "Écran principal"
        )
    }

    var noteProtectionOff: String {
        translate(
            zh: "保护已关闭，Dock 将按系统默认行为响应。",
            en: "Protection is off. Dock follows the system default behavior.",
            ja: "保護はオフです。Dockはシステム既定の動作に従います。",
            ko: "보호가 꺼져 있습니다. Dock은 시스템 기본 동작을 따릅니다.",
            es: "La protección está desactivada. El Dock seguirá el comportamiento predeterminado del sistema.",
            fr: "La protection est désactivée. Le Dock suit le comportement par défaut du système."
        )
    }

    var noteSingleDisplay: String {
        translate(
            zh: "当前只检测到一台显示器，连接第二台后会自动开始保护。",
            en: "Only one display detected. Protection starts automatically when another display is connected.",
            ja: "ディスプレイが1台のみ検出されています。2台目を接続すると自動的に保護が始まります。",
            ko: "디스플레이가 1대만 감지되었습니다. 두 번째 디스플레이를 연결하면 자동으로 보호가 시작됩니다.",
            es: "Solo se detectó una pantalla. La protección comenzará automáticamente cuando se conecte otra.",
            fr: "Un seul écran est détecté. La protection démarrera automatiquement lorsqu’un autre écran sera connecté."
        )
    }

    var noteMissingTargetDisplay: String {
        translate(
            zh: "目标显示器当前未连接，重新连接后会自动恢复。",
            en: "The target display is disconnected. Protection resumes automatically when it comes back.",
            ja: "対象ディスプレイが未接続です。再接続されると自動的に保護が再開します。",
            ko: "대상 디스플레이가 연결되어 있지 않습니다. 다시 연결되면 자동으로 보호가 재개됩니다.",
            es: "La pantalla objetivo no está conectada. La protección se reanudará automáticamente cuando vuelva.",
            fr: "L’écran cible n’est pas connecté. La protection reprendra automatiquement lorsqu’il sera reconnecté."
        )
    }

    var launchAtLoginApprovalRequired: String {
        translate(
            zh: "需要在系统设置的登录项中批准启用。",
            en: "Approval is required in System Settings > Login Items.",
            ja: "システム設定のログイン項目で許可が必要です。",
            ko: "시스템 설정의 로그인 항목에서 승인이 필요합니다.",
            es: "Se requiere aprobación en Configuración del Sistema > Ítems de inicio.",
            fr: "Une autorisation est requise dans Réglages Système > Ouverture."
        )
    }

    var launchAtLoginUpdateFailed: String {
        translate(
            zh: "当前构建无法更新开机自动启动设置。",
            en: "This build couldn't update Launch at Login.",
            ja: "このビルドではログイン時起動の設定を更新できません。",
            ko: "현재 빌드에서는 자동 실행 설정을 업데이트할 수 없습니다.",
            es: "Esta compilación no pudo actualizar el inicio al abrir sesión.",
            fr: "Cette version n’a pas pu mettre à jour le lancement à l’ouverture de session."
        )
    }

    var openSystemSettings: String {
        translate(
            zh: "打开系统设置",
            en: "Open System Settings",
            ja: "システム設定を開く",
            ko: "시스템 설정 열기",
            es: "Abrir Configuración del Sistema",
            fr: "Ouvrir Réglages Système"
        )
    }

    var close: String {
        translate(
            zh: "关闭",
            en: "Close",
            ja: "閉じる",
            ko: "닫기",
            es: "Cerrar",
            fr: "Fermer"
        )
    }

    func appearanceTitle(_ appearance: AppAppearance) -> String {
        switch appearance {
        case .system:
            followSystem
        case .light:
            light
        case .dark:
            dark
        }
    }

    func dockEdgeTitle(_ edge: DockEdge) -> String {
        switch edge {
        case .bottom:
            translate(zh: "底部", en: "Bottom", ja: "下部", ko: "하단", es: "Inferior", fr: "Bas")
        case .left:
            translate(zh: "左侧", en: "Left", ja: "左側", ko: "왼쪽", es: "Izquierda", fr: "Gauche")
        case .right:
            translate(zh: "右侧", en: "Right", ja: "右側", ko: "오른쪽", es: "Derecha", fr: "Droite")
        }
    }

    private func translate(
        zh: String,
        en: String,
        ja: String,
        ko: String,
        es: String,
        fr: String
    ) -> String {
        switch resolvedLanguage {
        case .system:
            en
        case .chinese:
            zh
        case .english:
            en
        case .japanese:
            ja
        case .korean:
            ko
        case .spanish:
            es
        case .french:
            fr
        }
    }
}
