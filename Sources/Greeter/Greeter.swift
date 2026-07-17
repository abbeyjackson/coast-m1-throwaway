/// Public greeting API for the Greeter module.
public struct Greeter {
    public init() {}

    public func greet(name: String) -> String {
        "Hello, \(name)!"
    }

    public func greet() -> String {
        "Hello, world!"
    }
}
