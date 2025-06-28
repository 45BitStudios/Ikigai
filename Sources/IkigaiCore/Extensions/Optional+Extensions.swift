import Foundation

public extension Optional where Wrapped == String {
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public extension Optional {
    func unwrap(defaultValue: Wrapped) -> Wrapped {
        guard let self = self else {
            
            // Make the app crash in debug but not in production
            assertionFailure("nil value")
            return defaultValue
        }
        return self
    }
}

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}