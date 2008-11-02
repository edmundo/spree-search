= Search

This is an extension that adds sort and search support for products inside Spree.

It includes basic name search that is suggested to be putted in a layout. It can be used in the main page or inside a taxon.
It can be tested using the following route:
/search/test

It includes extended search based on some criteria like name, price and classification it is directly in or below it.
It can be tested using the following route:
/searches/new

It has basic sort support for products, by default the only view that has it working is the result of the extended search, but it can be included in all the rest of the application including the main view and the view by current taxon.


gems needed:
activerecord-tableless

