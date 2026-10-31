ObjC.import('AppKit');

function run(args) {
    // Shift, Control, Option and Command. Wait for physical shortcut release
    // so Option cannot turn Command+Space into Finder's search shortcut.
    const modifiers = 0x1e0000;
    if (args.indexOf('--check') !== -1) {
        return 'Modifier detection available: ' + (Number($.NSEvent.modifierFlags) & modifiers);
    }
    const deadline = Date.now() + 10000;
    while ((Number($.NSEvent.modifierFlags) & modifiers) !== 0) {
        if (Date.now() >= deadline) return;
        delay(0.02);
    }
    Application('System Events').keyCode(49, {using: ['command down']});
}
