# [library] colorful text
- [Credits](https://gamesense.pub/forums/viewtopic.php?id=37410)

# Usage:
This is the code for the example console logs.
```
client_log("Default logging..");

colorful_text:log(
    { { 181, 230, 29 }, "[gamesense] " },
    { { 255, 33, 137 }, { 161, 80, 240 }, "Custom logging..", true }
);

colorful_text:log(
    { "Plain color logging..", true },
    { { 255, 150, 0 }, "Single color logging..", true },
    { { 255, 33, 137 }, { 161, 80, 240 }, "Blended color logging..", true }
);```

```colorful_text:lerp
Takes in either (table, table, number) or (number, number, number.)
Returns a lerped value.

colorful_text:console
Takes in either { { r, g, b }, string }, { { r, g, b }, { r, g, b }, string }.
Prints to console without a newline, you'll need to add it to the string for it to newline.

colorful_text:text
Takes in { { r, g, b }, string }, { { r, g, b }, { r, g, b }, string }, or string.
Optional arguments that can be placed anywhere within the arguments:
    A number indicating the alpha for the full string.
    A boolean indicating if the text is for the menu or not.
Returns the string with hex within.

colorful_text:log
Takes in { { r, g, b }, string, boolean? }, { { r, g, b }, { r, g, b }, string, boolean? }, { string, boolean? }.
The boolean must be at the end of the table, and only needs to be there if you are wanting to newline after the text.
```
