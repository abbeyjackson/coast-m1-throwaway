/// Greeting service: produces the app's greetings (plan item F-M1-i001).
public struct Greeter {
    public init() {}

    public func greet(name: String) -> String {
        "Hello, \(name)!"
    }

    public func greet() -> String {
        greet(name: "world")
    }
}
