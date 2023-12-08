public class AOCDay1Task1 {

    public class MatchResult {
        public Integer theIndex { get; set; }
        public Integer theNumber { get; set; }
    }

    public static Integer processStrings(Id inputContentDocId) {

        List<String> inputLines = readLinesFromDocument(inputContentDocId);

        List<Integer> results = new List<Integer>();
        
        for (String line : inputLines) {
            // Process each line and get the first and last characters

            results.add(findFirstAndLastNumbers(line));
        }

        Integer theKingInt = 0;

        for (Integer theInt : results) {
            theKingInt = theKingInt + theInt;
        }
        
        return theKingInt;
    }

    /**
     * Need to refactor this to take into account string values 'one', 'two', 'three', etc.
     */
    public static Integer findFirstAndLastNumbers(String inputString) {
        Integer firstNumberIndex = -1;
        String theFirstNumber;
        Integer lastNumberIndex = -1;
        String theLastNumber;

        String theFinalNumber;
        String theBeginningNumber;

        // Regex pattern match to all possible number strings 1-9, return the indexes of first and last numbers
        List<MatchResult> regexMatches = findPatternIndices(inputString);

        System.debug(regexMatches);

        // Process the string to get first and last integer indicies
        for (Integer i = 0; i < inputString.length(); i++) {
            if (inputString.substring(i, i+1).isNumeric()) {
                if (firstNumberIndex == -1) {
                    // Found the first number
                    firstNumberIndex = i;
                    MatchResult numberStats = new MatchResult();
                    numberStats.theIndex = i;
                    numberStats.theNumber = Integer.valueOf(inputString.substring(i, i+1));
                    regexMatches.add(numberStats);
                }
                // Update the last number index in each iteration
                lastNumberIndex = i;
                MatchResult numberStats = new MatchResult();
                numberStats.theIndex = i;
                numberStats.theNumber = Integer.valueOf(inputString.substring(i, i+1));
                regexMatches.add(numberStats);
            }
        }

        System.debug(regexMatches);

        Integer theLargestIndex = 0;
        Integer theSmallestIndex = 1000;

        for (MatchResult regexIndex :regexMatches) {
            if (regexIndex.theIndex > theLargestIndex) {
                theLargestIndex = regexIndex.theIndex;
            }

            if (regexIndex.theIndex < theSmallestIndex) {
                theSmallestIndex = regexIndex.theIndex;
            }
        }

        for (MatchResult theMatch :regexMatches) {
            if (theMatch.theIndex == theSmallestIndex) {
                theBeginningNumber = String.valueOf(theMatch.theNumber);
            }
            if (theMatch.theIndex == theLargestIndex) {
                theFinalNumber = String.valueOf(theMatch.theNumber);
            }
        }

        System.debug('First number found at index: ' + theSmallestIndex);
        System.debug('First number is: ' + theBeginningNumber);

        System.debug('Last number found at index: ' + theLargestIndex);
        System.debug('Last number is: ' + theFinalNumber);


        String theConcatNumber = theBeginningNumber + theFinalNumber;

        Integer theReturnNumber = Integer.valueOf(theConcatNumber);

        System.debug('The total number is: ' + theReturnNumber);

        return theReturnNumber;
    }

    public static List<MatchResult> findPatternIndices(String input) {
        // Create a pattern with the specified words
        //String pattern = '(one|two|three|four|five|six|seven|eight|nine)';
        Pattern regex = Pattern.compile('(one|two|three|four|five|six|seven|eight|nine)');

        // Create a matcher
        Matcher matcher = regex.matcher(input);

        List<MatchResult> results = new List<MatchResult>();

        // Find all matches
        while (matcher.find()) {
            MatchResult result = new MatchResult();
            result.theIndex = matcher.start();
            result.theNumber = wordToNumber(matcher.group());
            results.add(result);
        }

        return results;
    }

    private static Integer wordToNumber(String word) {
        switch on word.toLowerCase() {
            when 'one' { return 1; }
            when 'two' { return 2; }
            when 'three' { return 3; }
            when 'four' { return 4; }
            when 'five' { return 5; }
            when 'six' { return 6; }
            when 'seven' { return 7; }
            when 'eight' { return 8; }
            when 'nine' { return 9; }
            when else { return null; }
        }
    }

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