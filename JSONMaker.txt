// UDFB: JSONMaker
// This User Defined Function Block (UDFB) concatenates an array of strings into a JSON formatted string.
// It is designed for use in Rockwell Micro850 PLCs using Structured Text (ST).
// The function block takes an input array of up to 20 strings and outputs a JSON string with keys "A" to "T".
// Only non-empty strings are included in the output JSON.

// FUNCTION_BLOCK JSONMaker
// Input array: up to 20 strings, each up to 32 characters
// VAR_INPUT
//    InArray : ARRAY[0..19] OF STRING[32]; // Input array of strings
// END_VAR
// Output: JSON string
// VAR_OUTPUT
 //   JsonString : STRING[255]; // Output JSON string
// END_VAR
// Internal variables
// VAR
//    i : DINT;                // Loop index
//    first : BOOL;            // Flag to track first entry for comma placement
//    strLen : DINT;           // Current length of JsonString
//    letter : STRING[1];      // Key letter for JSON (A-T)
//END_VAR
// Control flags
// VAR
//    FBEN : BOOL;             // Enable flag for function block
//    FBENO : BOOL;            // Done flag for function block
// END_VAR

// Main logic: Only run when FBEN is TRUE
IF FBEN THEN
    first := TRUE; // Set first flag to TRUE for comma logic
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
            // Build the key letter (A-T) for this entry
            letter := CHAR(65 + i);
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, '"', strLen + 1); // Open key quote
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, letter, strLen + 1); // Key letter
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, '":"', strLen + 1); // Key-value separator
            // Append the value string
            strLen := MLEN(JsonString);
            JsonString := INSERT(JsonString, InArray[i], strLen + 1); // Value
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
