# QA inventory

## User-visible claims

1. The home screen has one animated warm-yellow office-cat hero with subtle zoom, falling coins, and a glowing salary envelope.
2. The native suggestion cards, real project selector, native composer, navigation, and task content remain interactive.
3. Sidebar and normal task views use the cream, taupe, cocoa, and sage palette without reduced readability.
4. Route changes and renderer reloads are reinjected while the watcher runs.
5. Reduced-motion mode uses the static PNG and disables CSS animations.
6. Restore removes injected DOM/CSS without changing the official application bundle or `app.asar`.

## Functional checks

- Click a native home suggestion and confirm the real action occurs.
- Click the real project button under “今天在哪儿打工？” and confirm the native menu opens.
- Type in the composer, verify caret/readability, then clear it without sending.
- Open a task, return to New Task, and confirm the skin remains.
- Reload through CDP and confirm the marker returns.
- Remove live skin, verify the marker is absent, then reapply.

## Visual checks

- At 1280×820 the hero, two-to-four native cards, project selector, and composer remain visible without horizontal scrolling.
- Confirm the GIF moves but does not flash or move text/controls.
- Confirm falling decorative coins never intercept pointer input.
- Narrow windows may hide the circular cat sticker, but must retain the hero and composer.
- Reject clipped cards, mixed Dream/Salary Cat styles, unreadable code diffs, detached project labels, or decoration over controls.
