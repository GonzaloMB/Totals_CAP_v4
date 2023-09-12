sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'poc/poctotals/test/integration/FirstJourney',
		'poc/poctotals/test/integration/pages/BooksList',
		'poc/poctotals/test/integration/pages/BooksObjectPage'
    ],
    function(JourneyRunner, opaJourney, BooksList, BooksObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('poc/poctotals') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBooksList: BooksList,
					onTheBooksObjectPage: BooksObjectPage
                }
            },
            opaJourney.run
        );
    }
);