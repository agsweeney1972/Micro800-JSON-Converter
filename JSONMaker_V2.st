// ------------------------------------------------------------
// UDFB: JSONMaker_V2
// Description:
//   Concatenates an array of strings into a JSON-formatted string.
//   For each non-empty input string, a key-value pair is added to the JSON output.
//   The key is taken from the corresponding InputNames entry if provided; otherwise,
//   it falls back to the letters "A" through "T" (for indices 0 to 19).
//   Designed for Rockwell Micro850 PLCs using Structured Text (ST).
//   Only non-empty strings are included in the output JSON.
//   Output is limited to 255 characters.
// ------------------------------------------------------------

// FUNCTION_BLOCK JSONMaker_V2
(*
VAR_INPUT
   InArray : ARRAY[0..19] OF STRING[32]; // Input array of strings to be converted to JSON values
   InputNames : ARRAY[0..19] OF STRING[32]; // Optional key names for each input; if blank, uses fallback key (A-T)
END_VAR

VAR_OUTPUT
   JsonString : STRING[255]; // Output JSON string containing key-value pairs
END_VAR

VAR
   i      : DINT;      // Loop index for traversing input arrays
   first  : BOOL;      // Tracks if the current entry is the first (for comma placement)
   strLen : DINT;      // Current length of JsonString
   key    : STRING[32]; // Key for JSON (from InputNames or fallback A-T)
END_VAR

VAR
   FBEN  : BOOL;  // Enable flag for function block execution
   FBENO : BOOL;  // Done flag for function block
END_VAR
*)

// Main logic: Only run when FBEN is TRUE
IF FBEN THEN
    first := TRUE; // Initialize first-entry flag for comma logic
    JsonString := '{'; // Start JSON string
    // Loop through all 20 elements of the input array
    FOR i := 0 TO 19 DO
        // Only process non-empty strings
        IF MLEN(InArray[i]) > 0 THEN
            IF first THEN
                // First valid entry, no comma needed
                first := FALSE;
            ELSE
                // Add comma before subsequent entries
                strLen := MLEN(JsonString);
                JsonString := INSERT(JsonString, ',', strLen + 1);
            END_IF;
            // Determine the key: use InputNames[i] if not blank, else fallback to A-T
            IF MLEN(InputNames[i]) > 0 THEN
                key := InputNames[i]; // Use provided key name
            ELSE
                key := CHAR(65 + i); // Fallback to letter A-T
            END_IF;
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, '"', strLen + 1); // Open key quote
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, key, strLen + 1); // Insert key
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, '":"', strLen + 1); // Key-value separator
            // Append the value string
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, InArray[i], strLen + 1); // Insert value
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, '"', strLen + 1); // Close value quote
        END_IF;
    END_FOR;
    // Close the JSON string
    strLen := MLEN(JsonString);
    JsonString := INSERT(JsonString, '}', strLen + 1);
    FBENO := TRUE; // Set done flag
ELSE
    FBENO := FALSE; // Not enabled, not done
END_IF;
