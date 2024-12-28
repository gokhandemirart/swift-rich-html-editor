"use strict";

// MARK: - Observation methods

function observeContentMutation(target, contentContainer) {
    let debounceTimer;

    const mutationObserver = new MutationObserver(() => {
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            reportContentDidChange(contentContainer.innerHTML);
        }, 300); 
    });

    mutationObserver.observe(target, { subtree: true, childList: true, characterData: true });
}

function observeResize(target) {
    const sizeObserver = new ResizeObserver(() => {
        let newContentHeight = document.documentElement.offsetHeight;
        reportContentHeightDidChange(newContentHeight);
    });
    sizeObserver.observe(target);
}

function observeSelectionChange(target) {
    target.addEventListener("selectionchange", () => {
        setTimeout(computeAndReportCaretPosition, 120);
        reportSelectedTextAttributesIfNecessary();
    });
}
