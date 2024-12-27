"use strict";

document.addEventListener("DOMContentLoaded", () => {
    reportEditorDidLoad();

    observeResize(document.documentElement);
    observeContentMutation(document, getEditor());
    observeSelectionChange(document);
});

document.addEventListener('paste', function(event) {
    let clipboardData = event.clipboardData || window.clipboardData;
    let text = clipboardData.getData('Text');
    
    event.preventDefault(); 
    document.execCommand('insertText', false, text);
});
