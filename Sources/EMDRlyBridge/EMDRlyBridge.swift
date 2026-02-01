// EMDRlyBridge - Shared data models for EMDRly
//
// This package contains all DTOs (Data Transfer Objects) shared between
// the EMDRly client app and server. All models are designed for:
// - On-device storage (HIPAA compliant, privacy-first)
// - Optional anonymized sync to therapist portal
// - Swift 6 Sendable conformance

import Foundation

// MARK: - Re-exports for convenience

// User models
@_exported import struct Foundation.UUID
@_exported import struct Foundation.Date

// MARK: - Version Info

public struct EMDRlyBridgeInfo {
    public static let version = "1.0.0"
    public static let buildDate = "2025-01-28"

    /// Privacy notice shown to users
    public static var privacyNotice: String {
        """
        EMDRly stores all your personal data on your device only. Your memories, \
        dreams, feelings, and journal entries never leave your phone unless you \
        explicitly choose to share specific items with your therapist.

        When you chat with the AI companion, your messages are processed locally \
        on your device. If the local AI cannot provide a helpful response, we may \
        send an anonymized version of your message (with no identifying information) \
        to generate a response.

        Your therapist can only see:
        - Aggregate metrics (if you enable sharing)
        - Items you specifically flag for discussion
        - Crisis alerts (if you enable this feature)

        They never see the full content of your entries unless you share them.
        """
    }

    /// Disclaimer about not being therapy
    public static var therapyDisclaimer: String {
        """
        EMDRly is NOT a replacement for therapy and does not provide any therapeutic \
        interventions. It is a journaling and reflection companion designed to support \
        you between sessions.

        This app does not:
        - Provide EMDR therapy or any eye movement exercises
        - Diagnose any conditions
        - Offer therapeutic advice
        - Replace your relationship with your therapist

        If you are in crisis, please contact your therapist, call 988 (Suicide & Crisis \
        Lifeline), or go to your nearest emergency room.
        """
    }
}
