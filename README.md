# [library] colorful text
- [Credits](https://gamesense.pub/forums/viewtopic.php?id=37410)

# Usage:
This is the code for the example console logs.
```client_log("Default logging..");

colorful_text:log(
    { { 181, 230, 29 }, "[gamesense] " },
    { { 255, 33, 137 }, { 161, 80, 240 }, "Custom logging..", true }
);

colorful_text:log(
    { "Plain color logging..", true },
    { { 255, 150, 0 }, "Single color logging..", true },
    { { 255, 33, 137 }, { 161, 80, 240 }, "Blended color logging..", true }
);```
