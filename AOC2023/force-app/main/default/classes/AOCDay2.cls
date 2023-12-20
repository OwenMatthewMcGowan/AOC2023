public with sharing class AOCDay2 {

    public class MatchResult {
        public String theColour { get; set; }
        public Integer theNumber { get; set; }
        public Integer theIndex { get; set; }
    }

    public static void AOCDay2(Id theContentDocId) {
        Integer numOfRedCubes = 12;
        Integer numOfGreenCubes = 13;
        Integer numOfBlueCubes = 14;
        Boolean countGame = true;
        Integer theTotal = 0;
        Integer totalPower = 0;

        List<String> inputStrings = readLinesFromDocument(theContentDocId);
        //String string1 = 'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green'; // Possible 
        //String string2 = 'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue'; // Possible
        //String string3 = 'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red'; // Not Possible
        //String string4 = 'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red'; // Not Possible
        //String string5 = 'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green'; // Possible

        // Total should be 8
    
        //inputStrings.add(string1);
        //inputStrings.add(string2);
        //inputStrings.add(string3);
        //inputStrings.add(string4);
        //inputStrings.add(string5);

        for (String theString : inputStrings) {

            // For each Game 'theString' - we want to find the minimum values of red, green, and blue cubes across all draws


            //countGame = true;
            // Split the string by : to seperate the game number from the number of cubes
            List<String> splitString = theString.split(':');
            // Check the second string in the list for any colour numbers greater than the limiting number - if found ignore, if not take the number from the first string to add
            List<MatchResult> theColourDetails = findPatternIndices(splitString[1]);

            // Keep track of the smallest numbers for each colour
            Integer smallestRedNumber = 0;
            Integer smallestGreenNumber = 0;
            Integer smallestBlueNumber = 0;

            // Check whether our details exceed the limits
            for (MatchResult theMatches : theColourDetails) {
                System.debug(theMatches.theColour);
                System.debug(theMatches.theNumber);
                if (theMatches.theColour == 'red' && theMatches.theNumber > smallestRedNumber) {
                    smallestRedNumber = theMatches.theNumber;
                    //countGame = false;
                } else if (theMatches.theColour == 'blue' && theMatches.theNumber > smallestBlueNumber) {
                    smallestBlueNumber = theMatches.theNumber;
                    //countGame = false;
                } else if (theMatches.theColour == 'green' && theMatches.theNumber > smallestGreenNumber) {
                    smallestGreenNumber = theMatches.theNumber;
                    //countGame = false;
                }
            }

            System.debug('The smallest number of reds is: ' + smallestRedNumber);
            System.debug('The smallest number of greens is: ' + smallestGreenNumber);
            System.debug('The smallest number of blues is: ' + smallestBlueNumber);

            Integer gamePower = smallestRedNumber*smallestBlueNumber*smallestGreenNumber;

            System.debug('The Game power is: ' + gamePower);

            totalPower = totalPower + gamePower;

            System.debug('The total power is rising! Now at: ' + totalPower);



            //if (countGame) {
            //    theTotal = theTotal + extractNumber(splitString[0]);
            //}
            //System.debug('The total is now: ' + theTotal);
        }
    }



    public static List<MatchResult> findPatternIndices(String input) {
        // Create a pattern with the specified colours
        Pattern regex = Pattern.compile('(blue|red|green)');

        // Create a matcher
        Matcher matcher = regex.matcher(input);

        List<MatchResult> results = new List<MatchResult>();

        // Find all matches
        while (matcher.find()) {
            MatchResult result = new MatchResult();
            result.theIndex = matcher.start() - 2; // The number is always two behind the start index of the colour
            if (matcher.start() <= 6) { // First one will be at index 3
                result.theNumber = extractNumber(input.substring(0, matcher.start()));
            } else { // the rest we send a window of 6
                result.theNumber = extractNumber(input.substring(matcher.start() - 6, matcher.start())); //Integer.valueOf(input.substring(result.theIndex, result.theIndex + 1));
            }
            result.theColour = matcher.group();
            results.add(result);
        }

        System.debug(results);

        return results;
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

    public static Integer extractNumber(String input) {
        System.debug(input);
        System.debug(input.length());

        List<String> numberBuilder = new List<String>();

        for (Integer i = 0; i < input.length(); i++) {
            System.debug(input.substring(i, i+1));
            if (i < input.length() && input.substring(i, i+1).isNumeric()) {
                numberBuilder.add(input.substring(i, i+1));
                System.debug(String.valueOf(input.charAt(i)));
            }
        }

        if (numberBuilder.size() > 0) {
            String theFullNumber = null;
            // Found a number, parse and return it
            for (Integer i=0; i < numberBuilder.size(); i++) {
                if (theFullNumber == null) {
                    theFullNumber = numberBuilder[i];
                    System.debug(theFullNumber);

                } else {
                    theFullNumber = theFullNumber + numberBuilder[i];
                    System.debug(theFullNumber);

                }
            }

            return Integer.valueOf(theFullNumber);
        } else {
            // No number found
            return null;
        }
    }

}