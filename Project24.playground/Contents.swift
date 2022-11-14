import UIKit

var name = "Taylor"

let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3] // dangerous because if looped over it creates a loop inside a loop
// when checking for empty string always better to use string.isEmpty() rather then string.count == 0

// Useful String methods

// pre-suffix
let password = "123456"

password.hasPrefix("123")
password.hasSuffix("567")

extension String {
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    func deleteSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

// capitalize
let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

print(weather.capitalizedFirst)

// contains
let input = "I really like the Swift programming language"
print(input.contains("Swift"))
let languages = ["Pyton", "Java", "Ruby", "Swift", "Javascript"]
print(languages.contains("Swift"))

let result = languages.contains { arrayElement in
    input.contains(arrayElement)
}
// =>
let result2 = languages.contains(where: input.contains)

print(result)

// formatting, NSAttributedString
let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let attributedString2 = NSMutableAttributedString(string: string, attributes: attributes)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 10, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 36), range: NSRange(location: 12, length: 2))

extension String {
    var isNumeric: Bool {
        if let _ = Int.init(self) {
            return true
        }
        return false
    }
    
    var lines: [String] {
        return components(separatedBy: "\n")
    }
    
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) {
            return self
        }
        return prefix + self
    }
}

let s1 = "hotdog".withPrefix("hot")
let s2 = "cat".withPrefix("warm")

let isNum1 = "12".isNumeric
let isNum2 = "12.4".isNumeric
