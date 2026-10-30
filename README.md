# LC-3 Text Analyzer

A text analysis program written in LC-3 Assembly. The program accepts user input and calculates character, word, vowel, and space counts using memory operations, conditional branching, and subroutines.

- **Text input:** Reads characters from the keyboard and stores them in a fixed size memory buffer
- **Character counting:** Counts all entered characters
- **Word counting:** Identifies words using a state flag to handle consecutive spaces
- **Vowel counting:** Recognizes uppercase and lowercase vowels
- **Space counting:** Counts ASCII space characters
- **Decimal output:** Converts integer counts into printable ASCII digits

## Example Output

```text
Enter text: Hello world

RESULTS
Characters: 11
Words: 2
Vowels: 3
Spaces: 1
Analysis complete.
```

## Implementation

| Subroutines
| `READ_INPUT` | Reads keyboard input using `GETC`, echoes characters using `OUT`, and stores text in a null terminated buffer
| `ANALYZE_TEXT` | Traverses the buffer and calculates character, word, vowel, and space counts
| `PRINT_RESULTS` | Displays the calculated statistics 
| `PRINT_NUMBER` | Converts integer counts into decimal ASCII output using repeated subtraction

The program uses a statically allocated buffer of 100 memory words, supporting up to 99 input characters plus a null terminator.

## Running the Program

1. Open an LC-3 assembler and simulator
2. Load `TextAnalyzer.asm`
3. Assemble the program
4. Run the program starting at address `x3000`
5. Type a line of text and press enter to display its statistics
