# Gavel

Mobile-optimized, streamlined bylaw complaints for the City of Hamilton, Ontario.

## Structure

Settings page lets you save, to local storage, your personal details.
Complaint page lets you enter the address and choose the type of complaint, which segues to:
The confirmation page, which shows the address, the complaint and complaint details, and has your personal details
  in hidden fields that are then POSTed to the server.

## To-do

* Fire off an AJAX request to Heroku when the app first loads, to spin up the instance of the app
* Don't have a type of complaint auto-filled out (OK)
* Reset the form after successful submission
* Record anonymized complaints on the web service
* Don't allow duplicate complaints on the web service
* Validate the settings and the complaint (OK)
* Show some kind of disclaimer when the app first loads (put it on the settings page)

Later:

* front-end caching using cache manifest

## Form Fields For POSTing To City Site

The city's website wants the form fields to be submitted as follows:

    __VIEWSTATE: An ASP.NET specific string that must be present.  We should be able to just fake this with the one
                 that it uses by default.
    idSearchString: Unsure, seems to typically be blank.
    COHShell:_ctl0:qQ_FNAME: First name of the complainant.
    COHShell:_ctl0:qQ_ADDRESS: Address of the complainant.
    COHShell:_ctl0:qQ_LNAME: Last name of the complainant.
    COHShell:_ctl0:qQ_PCODE: Postal code of the complainant.
    COHShell:_ctl0:qQ_HOMEPHONE: Home phone of the complainant.
    COHShell:_ctl0:qQ_CITY_CONTACT: City of the complainant.
    COHShell:_ctl0:qQ_WORKNUMBER: Secondary phone of the complainant.
    COHShell:_ctl0:qQ_EMAIL: Email address of the complainant.
    COHShell:_ctl0:qQ_VADDRESS: Address of the problem.
    COHShell:_ctl0:qQ_CITY: City of the problem.
    COHShell:_ctl0:qQ_VFNAME: First name of the problematic person.
    COHShell:_ctl0:qQ_VLNAME: Last name of the problematic person.
    COHShell:_ctl0:qQ_COMPOLD:
    COHShell:_ctl0:qQ_COMP: Nature of complaint, can be:
      Barking Dogs
      Business Licences
      Dog feces (accumulation in residential backyard)
      Exterior Property Maintenance (roof, windows, doors etc. that are broken or in need of major repair)
      Garbage and Debris (residential and/or commercial properties)
      Garbage dumping (garbage dumped on public properties or back alleys, ditches etc.)
      Illegal use of property (zoning)
      Interior Property Maintenance (rental properties) 
      Long grass (more than 8 inches)
      Noise (only noise during the day due to construction projects, large machines or equipment etc.)
      Potential Vacant Building
      Signs
      Snow and Ice (snow or ice that hasn't been cleared within 24 hours of a snow fall)
      Other
    COHShell:_ctl0:qQ_OCOMP: Other complaint text.
    COHShell:_ctl0:qQ_COMMENTS: Additional comments.
    COHShell:_ctl0:Button1:Submit Form
