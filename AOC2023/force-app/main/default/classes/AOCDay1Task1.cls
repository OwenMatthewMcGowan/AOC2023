public class AOCDay1Task1 {
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
    
    private static String getTwoDigitNumber(String input) {
        String firstCharacter = input.substring(0, 1);
        String lastCharacter = input.substring(Math.max(input.length() - 1, 0));
        
        return firstCharacter + lastCharacter;
    }

    public static Integer findFirstAndLastNumbers(String inputString) {
        Integer firstNumberIndex = -1;
        String theFirstNumber;
        Integer lastNumberIndex = -1;
        String theLastNumber;

        for (Integer i = 0; i < inputString.length(); i++) {
            if (inputString.substring(i, i+1).isNumeric()) {
                if (firstNumberIndex == -1) {
                    // Found the first number
                    firstNumberIndex = i;
                    theFirstNumber = inputString.substring(i, i+1);

                }
                // Update the last number index in each iteration
                lastNumberIndex = i;
                theLastNumber = inputString.substring(i, i+1);
            }
        }


        if (firstNumberIndex != -1 && lastNumberIndex != -1) {
            System.debug('First number found at index: ' + firstNumberIndex);
            System.debug('First number is: ' + theFirstNumber);

            System.debug('Last number found at index: ' + lastNumberIndex);
            System.debug('Last number is: ' + theLastNumber);
        } else {
            System.debug('No numbers found in the input string.');
        }

        String theConcatNumber = theFirstNumber + theLastNumber;

        Integer theReturnNumber = Integer.valueOf(theConcatNumber);

        System.debug('The total number is: ' + theReturnNumber);

        return theReturnNumber;
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