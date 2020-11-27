// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Ok
  internal static let alertConfirmation = L10n.tr("Localizable", "alert_confirmation")
  ///  • 
  internal static let bulletPoint = L10n.tr("Localizable", "bullet_point")
  /// Closed
  internal static let candidateRestaurantClosed = L10n.tr("Localizable", "candidate_restaurant_closed")
  /// Open
  internal static let candidateRestaurantOpen = L10n.tr("Localizable", "candidate_restaurant_open")
  /// Error
  internal static let error = L10n.tr("Localizable", "error")
  /// Filter
  internal static let filter = L10n.tr("Localizable", "filter")
  /// Open Now
  internal static let filterOpenNow = L10n.tr("Localizable", "filter_open_now")
  /// List
  internal static let listViewButton = L10n.tr("Localizable", "list_view_button")
  /// Please change your location permissions in Settings in order to use AllTrails at Lunch.
  internal static let locationPermissionsRequired = L10n.tr("Localizable", "location_permissions_required")
  /// Map
  internal static let mapViewButton = L10n.tr("Localizable", "map_view_button")
  /// %@ stars
  internal static func ratingsStarAccessibilityLabel(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ratings_star_accessibility_label", String(describing: p1))
  }
  /// %@ ratings
  internal static func ratingsTotalAccessibilityLabel(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ratings_total_accessibility_label", String(describing: p1))
  }
  /// (%@)
  internal static func ratingsTotalLabel(_ p1: Any) -> String {
    return L10n.tr("Localizable", "ratings_total_label", String(describing: p1))
  }
  /// For best results, please enter a search term.
  internal static let resultsQualitySuggestion = L10n.tr("Localizable", "results_quality_suggestion")
  /// Search for a restaurant
  internal static let searchForARestaurant = L10n.tr("Localizable", "search_for_a_restaurant")
  /// Tip
  internal static let tip = L10n.tr("Localizable", "tip")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
