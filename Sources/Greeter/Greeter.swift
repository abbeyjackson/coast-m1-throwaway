/// Public greeting API for the Greeter module.
public struct Greeter {
    public init() {}

    /// Returns a greeting addressed to `name`, e.g. "Hello, Ada!".
    ///
    /// - Parameter name: The name to greet. Passed through verbatim,
    ///   including empty strings.
    /// - Returns: "Hello, <name>!".
    public func greet(name: String) -> String {
        "Hello, \(name)!"
    }

    /// Returns the generic greeting "Hello, world!" for callers with no
    /// specific name to greet.
    ///
    /// Delegates to `greet(name:)` so the two overloads can never drift
    /// out of sync with each other.
    ///
    /// - Returns: "Hello, world!".
    public func greet() -> String {
        greet(name: "world")
    }
}
