public with sharing class AOCDay3 {

    public class MatchResult {
        public String theType { get; set; } // Indicates whether it's a 'number', or a 'character' match
        public String theValue { get; set; } // Stores the regex matched value
        public Integer theYAxis { get; set; } // Keeps track of the y position of the number
        public Integer theXAxisStart { get; set; }
        public Integer theXAxisEnd { get; set; }
    }

    public static void AOCDay3(Id theContentDocId) {
        Integer theYCount = 0;
        List<String> countedNumbers = new List<String>();
        Map<Integer, List<MatchResult>> totalMatchedNumbers = new Map<Integer, List<MatchResult>>();
        Map<Integer, List<MatchResult>> totalMatchedChars = new Map<Integer, List<MatchResult>>();

        List<String> inputStrings = readLinesFromDocument(theContentDocId);

        // For each string keep a count of the line (y-axis value), so I can map in 2D
        for (String theString : inputStrings) {
            System.debug(theString);

            // Extract all numeric values
            List<MatchResult> theMatchedNumbers = extractNumbers(theString, theYCount);
            totalMatchedNumbers.put(theYCount, theMatchedNumbers);

            // Extract all special characters
            List<MatchResult> theMatchedChars = extractSpecialChars(theString, theYCount);
            totalMatchedChars.put(theYCount, theMatchedChars);

            theYCount++;
        }

        System.debug(totalMatchedChars.size());
        System.debug(totalMatchedChars.size());

        // Work out which numeric values to count
        for (Integer i = 0; i < inputStrings.size(); i++) {
        
            for (MatchResult theNumbers : totalMatchedNumbers.get(i)) {
                Boolean countNumber = false;
                if (i == 0) {
                    // On the first row, therefore only check this row or one below
                    List<MatchResult> relevantChars = new List<MatchResult>();
                    if (totalMatchedChars.get(i) != null) {
                        relevantChars.addAll(totalMatchedChars.get(i));
                    }
                    if (totalMatchedChars.get(i+1) != null) {
                        relevantChars.addAll(totalMatchedChars.get(i+1));
                    }
                    for (MatchResult theRelevantChars : relevantChars) {
                        if (theRelevantChars.theXAxisEnd >= theNumbers.theXAxisStart -1 && theRelevantChars.theXAxisStart <= theNumbers.theXAxisEnd + 1) {
                            countNumber = true;
                        }
                    }
                } else if (i == inputStrings.size()) {
                    // On the last row, therefore only check this row or one above
                    List<MatchResult> relevantChars = new List<MatchResult>();
                    if (totalMatchedChars.get(i-1) != null) {
                        relevantChars.addAll(totalMatchedChars.get(i-1));
                    }
                    if (totalMatchedChars.get(i) != null) {
                        relevantChars.addAll(totalMatchedChars.get(i));
                    }
                    for (MatchResult theRelevantChars : relevantChars) {
                        if (theRelevantChars.theXAxisEnd >= theNumbers.theXAxisStart -1 && theRelevantChars.theXAxisStart <= theNumbers.theXAxisEnd + 1) {
                            countNumber = true;
                        }
                    }
                } else {
                    // On a middle row, so we check one above and below
                    List<MatchResult> relevantChars = new List<MatchResult>();
                    if (totalMatchedChars.get(i-1) != null) {
                        relevantChars.addAll(totalMatchedChars.get(i-1));
                    }
                    if (totalMatchedChars.get(i) != null) {
                        relevantChars.addAll(totalMatchedChars.get(i));
                    }
                    if (totalMatchedChars.get(i+1) != null) {
                        relevantChars.addAll(totalMatchedChars.get(i+1));
                    }
                    for (MatchResult theRelevantChars : relevantChars) {
                        if (theRelevantChars.theXAxisEnd >= theNumbers.theXAxisStart -1 && theRelevantChars.theXAxisStart <= theNumbers.theXAxisEnd + 1) {
                            countNumber = true;
                        }
                    }
                }

                if (countNumber) {
                    countedNumbers.add(theNumbers.theValue);
                }
            }
        }

        // Sum them up
        extractNumber(countedNumbers);
    }

    public static Integer extractNumber(List<String> input) {
        System.debug(input);

        if (input.size() > 0) {
            Integer theFullNumber = null;
            // Found a number, parse and return it
            for (Integer i=0; i < input.size(); i++) {
                if (theFullNumber == null) {
                    theFullNumber = Integer.valueOf(input[i]);
                    System.debug(theFullNumber);

                } else {
                    theFullNumber = theFullNumber + Integer.valueOf(input[i]);
                    System.debug('The Full Number is: ' + theFullNumber);

                }
            }

            return Integer.valueOf(theFullNumber);
        } else {
            // No number found
            return null;
        }
    }

    /**

    /**
     * Extracts any numbers from the input string
     */
    public static List<MatchResult> extractNumbers(String inputString, Integer yAxisCount) {
        List<MatchResult> numbers = new List<MatchResult>();
        
        // Regular expression to find all numbers in the string
        Pattern regex = Pattern.compile('\\b\\d+\\b');
        Matcher matcher = regex.matcher(inputString);

        while (matcher.find()) {
            String theType = 'number';
            String theValue = matcher.group();
            Integer theYAxis = yAxisCount;
            Integer theXAxisStart = matcher.start();
            Integer theXAxisEnd = matcher.end() - 1; // Adjusting for 0-based indexing

            MatchResult numberInfo = new MatchResult();
            numberInfo.theType = theType; 
            numberInfo.theValue = theValue;
            numberInfo.theYAxis = theYAxis;
            numberInfo.theXAxisStart = theXAxisStart;
            numberInfo.theXAxisEnd = theXAxisEnd;
            System.debug(numberInfo);
            numbers.add(numberInfo);
        }

        return numbers;
    }

    /**
     * Extracts any special characters which are not . 
     */
    public static List<MatchResult> extractSpecialChars(String inputString, Integer yAxisCount) {
        List<MatchResult> characters = new List<MatchResult>();

        for (Integer i = 0; i < inputString.length(); i++) {
            if (!inputString.substring(i, i+1).isNumeric() && !inputString.substring(i, i+1).equals('.')) {
                String theType = 'character';
                String theValue = inputString.substring(i, i+1);
                Integer theYAxis = yAxisCount;
                Integer theXAxisStart = i;
                Integer theXAxisEnd = i;

                MatchResult characterInfo = new MatchResult();
                characterInfo.theType = theType; 
                characterInfo.theValue = theValue;
                characterInfo.theYAxis = theYAxis;
                characterInfo.theXAxisStart = theXAxisStart;
                characterInfo.theXAxisEnd = theXAxisEnd;
                System.debug(characterInfo);
                characters.add(characterInfo);
            }
        }

        return characters;
    }

    /**
     * Reads input lines from the specified Content Document and returns an array of strings for each line
     */
    public static List<String> readLinesFromDocument(String contentDocumentId) {
        List<String> lines = new List<String>();
        
        try {
            // Query the Document object to get the Body field
            List<ContentVersion> theFileData = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId AND IsLatest = true];
            //Document doc = [SELECT Body FROM Document WHERE Id = :documentId LIMIT 1];
            Blob fileBlob = theFileData[0].VersionData;
            String fileContent = fileBlob.toString();
            System.debug(fileContent);

            // Split the content into lines
            lines = fileContent.split('\n');

        } catch (Exception e) {
            // Handle exceptions, e.g., document not found or permission issues
            System.debug('Exception: ' + e.getMessage());
        }

        return lines;
    }

}