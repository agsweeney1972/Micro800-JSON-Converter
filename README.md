# JSONMaker UDFB for Rockwell Micro850 (Structured Text)

## Overview
`JSONMaker` is a User Defined Function Block (UDFB) written in Structured Text for Rockwell Micro850 PLCs. It concatenates an input array of strings into a single JSON-formatted string, using keys "A" through "T" for up to 20 elements. Only non-empty strings are included in the output JSON.

![UDFB Overview](Images/JSONMaker_UFDB.png)

## Features
- Accepts an input array of up to 20 strings (`InArray`), each up to 32 characters.
- Outputs a JSON string (`JsonString`) with keys "A" to "T" corresponding to the array indices.
- Skips empty strings in the input array.
- Designed for use in Connected Components Workbench (CCW) with Micro850 PLCs.
- Controlled by enable (`FBEN`) and done (`FBENO`) flags.

## Function Block Interface

### Input Array
![Input Array](Images/JSONMaker_UDFB_InputArray.png)

- `InArray : ARRAY[0..19] OF STRING[32]`  
  The array of strings to be concatenated into JSON.
- `FBEN : BOOL`  
  Set to `TRUE` to enable execution of the function block.

### Output JSON
![Output JSON](Images/JSONMaker_UDFB_OutputJSON.png)

- `JsonString : STRING[255]`  
  The resulting JSON string.
- `FBENO : BOOL`  
  Set to `TRUE` when the function block has completed execution.

### Function Block Variables
![Function Block Variables](Images/JSONMaker_UDFB_FunctionBlockVariables.png)

## How It Works
1. When `FBEN` is set to `TRUE`, the function block starts execution.
2. It initializes the output string as a JSON object (`{"`).
3. It loops through each element of `InArray` (indices 0 to 19):
    - If the string is not empty, it adds a key-value pair to the JSON string.
    - The key is a letter from "A" (index 0) to "T" (index 19).
    - Commas are added between entries as needed.
4. The JSON string is closed with a `}`.
5. `FBENO` is set to `TRUE` to indicate completion.

## Example

Suppose you have the following input:

```pascal
InArray[0] := 'Apple';
InArray[1] := '';
InArray[2] := 'Banana';
InArray[3] := '';
InArray[4] := 'Cherry';
// ... rest are empty
FBEN := TRUE;
```

After execution, `JsonString` will be:

```json
{"A":"Apple","C":"Banana","E":"Cherry"}
```

## Usage Notes
- Only non-empty strings are included in the output JSON.
- The output string is limited to 255 characters. If the total JSON exceeds this, it will be truncated.
- The function block must be called with `FBEN := TRUE` to execute. `FBENO` will be set to `TRUE` when done.
- Designed for use in Micro850 PLCs as a UDFB written in Structured Text (ST) in CCW.

## License
This code is provided as-is for educational and industrial automation purposes.
