import Cocoa

class TextArea: NSTextField, NSTextFieldDelegate {
    static let padding = CGFloat(5)
    var callback: (() -> Void)!

    convenience init(_ nCharactersWide: CGFloat, _ nLinesHigh: Int, _ placeholder: String, _ callback: (() -> Void)? = nil) {
        self.init(frame: .zero)
        self.callback = callback
        delegate = self
        cell = TextFieldCell(placeholder, nLinesHigh == 1)
        fit(font!.xHeight * nCharactersWide + TextArea.padding * 2, fittingSize.height * CGFloat(nLinesHigh) + TextArea.padding * 2)
    }

    func controlTextDidChange(_ notification: Notification) {
        callback?()
    }

    // enter key inserts new line instead of submitting
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard commandSelector == #selector(NSResponder.insertNewline) else { return false }
        textView.insertNewlineIgnoringFieldEditor(self)
        return true
    }
}

// subclassing NSTextFieldCell is done uniquely to add padding
class TextFieldCell: NSTextFieldCell {
    convenience init(_ placeholder: String, _ usesSingleLineMode: Bool) {
        self.init()
        isBordered = true
        isBezeled = true
        isEditable = true
        font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        stringValue = ""
        placeholderString = placeholder
        self.usesSingleLineMode = usesSingleLineMode
    }

    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        return super.drawingRect(forBounds: NSMakeRect(
                rect.origin.x + TextArea.padding,
                rect.origin.y + TextArea.padding,
                rect.size.width - TextArea.padding * 2,
                rect.size.height - TextArea.padding * 2
        ))
    }
}