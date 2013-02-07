require 'sinatra'
require 'net/http'
require 'uri'
require 'pry'

get '/' do
  haml :index
end

# just to wake up Heroku instance when the app is first loaded
get '/wakeup' do
  "Woke up!"
end

get '/settings' do
  haml :settings
end

get '/confirm' do
  haml :confirm
end

post '/submit-complaint' do
  # Check the README for details on how the city wants its form fields submitted.
  post_params = {
    "__VIEWSTATE" => 'dDwxNzUyNDY0MDEzO3Q8O2w8aTwzPjs+O2w8dDw7bDxpPDU+O2k8MTE+O2k8MTM+Oz47bDx0PDtsPGk8MD47aTwyPjs+O2w8dDxwPGw8VGV4dDs+O2w8XDxkaXYgY2xhc3M9InN1Ym5hdiJcPg0KICBcPHVsXD4NCiAgICBcPGxpXD4NCiAgICAgIFw8YSBocmVmPSIvQ2l0eURlcGFydG1lbnRzL0NvbW11bml0eVNlcnZpY2UvIlw+DQogICAgICAgIFw8c3Ryb25nXD5Db21tdW5pdHkgU2VydmljZXNcPC9zdHJvbmdcPg0KICAgICAgXDwvYVw+DQogICAgXDwvbGlcPg0KICAgIFw8dWxcPg0KICAgIFw8L3VsXD4NCiAgICBcPGxpXD4NCiAgICAgIFw8YSBocmVmPSIvQ2l0eURlcGFydG1lbnRzL0NvbnRhY3RVcy8iXD4NCiAgICAgICAgXDxzdHJvbmdcPkNvbnRhY3QgVXNcPC9zdHJvbmdcPg0KICAgICAgXDwvYVw+DQogICAgXDwvbGlcPg0KICAgIFw8dWxcPg0KICAgIFw8L3VsXD4NCiAgICBcPGxpXD4NCiAgICAgIFw8YSBocmVmPSIvQ2l0eURlcGFydG1lbnRzL0NvcnBvcmF0ZVNlcnZpY2VzLyJcPg0KICAgICAgICBcPHN0cm9uZ1w+Q29ycG9yYXRlIFNlcnZpY2VzXDwvc3Ryb25nXD4NCiAgICAgIFw8L2FcPg0KICAgIFw8L2xpXD4NCiAgICBcPHVsXD4NCiAgICBcPC91bFw+DQogICAgXDxsaVw+DQogICAgICBcPGEgaHJlZj0iL0NpdHlEZXBhcnRtZW50cy9FbWVyZ2VuY3lTZXJ2aWNlcy8iXD4NCiAgICAgICAgXDxzdHJvbmdcPkVtZXJnZW5jeSBTZXJ2aWNlc1w8L3N0cm9uZ1w+DQogICAgI' + 
                     'CBcPC9hXD4NCiAgICBcPC9saVw+DQogICAgXDx1bFw+DQogICAgXDwvdWxcPg0KICAgIFw8bGlcPg0KICAgICAgXDxhIGhyZWY9Ii9DaXR5RGVwYXJ0bWVudHMvSHVtYW5SZXNvdXJjZXMvIlw+DQogICAgICAgIFw8c3Ryb25nXD5IdW1hbiBSZXNvdXJjZXNcPC9zdHJvbmdcPg0KICAgICAgXDwvYVw+DQogICAgXDwvbGlcPg0KICAgIFw8dWxcPg0KICAgIFw8L3VsXD4NCiAgICBcPGxpXD4NCiAgICAgIFw8YSBocmVmPSIvQ2l0eURlcGFydG1lbnRzL0NpdHlNYW5hZ2VyLyJcPg0KICAgICAgICBcPHN0cm9uZ1w+T2ZmaWNlIG9mIHRoZSBDaXR5IE1hbmFnZXJcPC9zdHJvbmdcPg0KICAgICAgXDwvYVw+DQogICAgXDwvbGlcPg0KICAgIFw8dWxcPg0KICAgIFw8L3VsXD4NCiAgICBcPGxpXD4NCiAgICAgIFw8YSBocmVmPSIvQ2l0eURlcGFydG1lbnRzL1BsYW5uaW5nRWNEZXYvIlw+DQogICAgICAgIFw8c3Ryb25nXD5QbGFubmluZyAmIEVjb25vbWljIERldmVsb3BtZW50XDwvc3Ryb25nXD4NCiAgICAgIFw8L2FcPg0KICAgIFw8L2xpXD4NCiAgICBcPHVsXD4NCiAgICBcPC91bFw+DQogICAgXDxsaVw+DQogICAgICBcPGEgaHJlZj0iL0NpdHlEZXBhcnRtZW50cy9QdWJsaWNIZWFsdGgvIlw+DQogICAgICAgIFw8c3Ryb25nXD5QdWJsaWMgSGVhbHRoICYgU29jaWFsIFNlcnZpY2VzXDwvc3Ryb25nXD4NCiAgICAgIFw8L2FcPg0KICAgIFw8L2xpXD4NCiAgICBcPHVsXD4NCiAgICBcPC91bF' + 
                     'w+DQogICAgXDxsaVw+DQogICAgICBcPGEgaHJlZj0iL0NpdHlEZXBhcnRtZW50cy9QdWJsaWNXb3Jrcy8iXD4NCiAgICAgICAgXDxzdHJvbmdcPlB1YmxpYyBXb3Jrc1w8L3N0cm9uZ1w+DQogICAgICBcPC9hXD4NCiAgICBcPC9saVw+DQogICAgXDx1bFw+DQogICAgXDwvdWxcPg0KICBcPC91bFw+DQpcPC9kaXZcPjs+Pjs7Pjt0PHA8bDxUZXh0Oz47bDxcPGRpdiBjbGFzcz0icG9wc3AiXD4NCiAgXDxkaXYgY2xhc3M9InBvcHVsYXJsaW5rcyJcPg0KICAgIFw8aDJcPlBvcHVsYXIgTGlua3NcPC9oMlw+DQogICAgXDx1bFw+DQogICAgICBcPGxpXD4NCiAgICAgICAgXDxhIGhyZWY9Imh0dHA6Ly93d3cuaHBsLmNhLyJcPkhhbWlsdG9uIFB1YmxpYyBMaWJyYXJ5XDwvYVw+DQogICAgICBcPC9saVw+DQogICAgICBcPGxpXD4NCiAgICAgICAgXDxhIGhyZWY9Imh0dHA6Ly93d3cuaGVjZmkuY2EvIlw+SEVDRkkgY29uY2VydHMgYW5kIGV2ZW50c1w8L2FcPg0KICAgICAgXDwvbGlcPg0KICAgICAgXDxsaVw+DQogICAgICAgIFw8YSBocmVmPSJodHRwOi8vd3d3LmludmVzdGluaGFtaWx0b24uY2EvIlw+SW52ZXN0IGluIEhhbWlsdG9uXDwvYVw+DQogICAgICBcPC9saVw+DQogICAgICBcPGxpXD4NCiAgICAgICAgXDxhIGhyZWY9Imh0dHA6Ly93d3cudG91cmlzbWhhbWlsdG9uLmNvbS8iXD5Ub3VyaXNtIEhhbWlsdG9uXDwvYVw+DQogICAgICBcPC9saVw+DQogICAgICBcPGxpXD4NCiAgICA' +
                     'gICAgXDxhIGhyZWY9Imh0dHA6Ly93d3cuaGFtaWx0b25wb2xpY2Uub24uY2EvIlw+SGFtaWx0b24gUG9saWNlIFNlcnZpY2VzXDwvYVw+DQogICAgICBcPC9saVw+DQogICAgXDwvdWxcPg0KICBcPC9kaXZcPg0KXDwvZGl2XD47Pj47Oz47Pj47dDxwPHA8bDxJc0NPSENvbnRyb2xDaGFuZ2VkOz47bDxGYWxzZTs+Pjs+O2w8aTwwPjtpPDI+Oz47bDx0PHA8cDxsPFZpc2libGU7PjtsPG88Zj47Pj47PjtsPGk8Mz47PjtsPHQ8dDw7dDxpPDA+O0A8PjtAPD4+Oz47Oz47Pj47dDw7bDxpPDA+Oz47bDx0PDtsPGk8MT47PjtsPHQ8O2w8aTwwPjs+O2w8dDw7bDxpPDU1Pjs+O2w8dDxwPHA8bDxDYXVzZXNWYWxpZGF0aW9uOz47bDxvPHQ+Oz4+Oz47Oz47Pj47Pj47Pj47Pj47Pj47dDw7bDxpPDA+O2k8Mj47PjtsPHQ8cDxsPFRleHQ7PjtsPFw8ZGl2IGNsYXNzPSJmb290ZXIiXD4NCiAgXDxkaXYgY2xhc3M9ImZvb3RuYXYiXD4NCiAgICBcPGEgaHJlZj0iaHR0cDovL3d3dy5oYW1pbHRvbi5jYS9wb2xpY2llcy9UZXJtcyJcPlRlcm1zIG9mIFVzZVw8L2FcPg0KICAgIFw8YSBocmVmPSJodHRwOi8vd3d3LmhhbWlsdG9uLmNhL3BvbGljaWVzL1ByaXZhY3kiXD5Qcml2YWN5IFN0YXRlbWVudFw8L2FcPg0KICAgIFw8YSBocmVmPSJodHRwOi8vd3d3LmhhbWlsdG9uLmNhL3BvbGljaWVzL0FjY2Vzc2liaWxpdHkiXD5BY2Nlc3NpYmlsaXR5IFN0YXRlbWVudFw8L2FcPg0KICAgIFw8YSBocmVmPSJodHRw' +
                     'Oi8vd3d3LmhhbWlsdG9uLmNhL0hlbHAvV2ViK0hlbHAvU2l0ZVJlcXVpcmVtZW50Ilw+U2l0ZSBSZXF1aXJlbWVudHNcPC9hXD4NCiAgICBcPGEgaHJlZj0iaHR0cDovL3d3dy5oYW1pbHRvbi5jYS9jb21tb24vQ29udGFjdFVzIlw+Q29udGFjdCBVc1w8L2FcPg0KICAgIFw8YSBocmVmPSJodHRwOi8vd3d3LmhhbWlsdG9uLmNhL2NvbW1vbi9TaXRlTWFwIlw+U2l0ZSBNYXBcPC9hXD4NCiAgICBcPGEgaHJlZj0iaHR0cDovL3d3dy5oYW1pbHRvbi5jYS9IZWxwL0NpdHkrb2YrSGFtaWx0b24rRkFRcyJcPkhlbHAgYW5kIEZBUXNcPC9hXD4NCiAgICBcPGEgdGFyZ2V0PSJfYmxhbmsiIGhyZWY9Imh0dHA6Ly93d3cub250YXJpby5jYS8iXD4NCiAgICAgIFw8aW1nIHNyYz0iaHR0cDovL3d3dy5oYW1pbHRvbi5jYS9IYW1pbHRvbi5Qb3J0YWwvSW5jL0ltYWdlcy9vbnRhcmlvX2xvZ28ucG5nIiBhbHQ9IiIgaWQ9Im9udGFyaW9sb2dvIiBib3JkZXI9IjAiIGhlaWdodD0iMjAiIHdpZHRoPSI2MCJcPg0KICAgIFw8L2FcPg0KICBcPC9kaXZcPg0KICBcPGRpdiBjbGFzcz0idG9wIlw+DQogICAgXDxhIGhyZWY9IiN0b3BvZnBhZ2UiXD5Ub3Agb2YgcGFnZVw8L2FcPg0KICBcPC9kaXZcPg0KICBcPHBcPkNvcHlyaWdodCDCqSAyMDEyIGhhbWlsdG9uLmNhIC0gSGFtaWx0b24sIE9udGFyaW8sIENhbmFkYVw8L3BcPg0KXDwvZGl2XD47Pj47Oz47dDw7bDxpPDA+O2k8MT47aTwyPjs+O2w8dDxwPGw8V' +
                     'mlzaWJsZTs+O2w8bzxmPjs+Pjs7Pjt0PHA8bDxWaXNpYmxlOz47bDxvPGY+Oz4+Ozs+O3Q8cDxsPFZpc2libGU7PjtsPG88Zj47Pj47Oz47Pj47Pj47Pj47Pj47bDxfeHBjTWV0YURhdGE7Pj5OwHs/MekAhEgMO/LfVIAa/1s7iw==',
    "idSearchString" => "",
    "COHShell:_ctl0:qQ_FNAME" => params[:first_name],
    "COHShell:_ctl0:qQ_ADDRESS" => params[:address],
    "COHShell:_ctl0:qQ_LNAME" => params[:last_name],
    "COHShell:_ctl0:qQ_PCODE" => params[:postal_code],
    "COHShell:_ctl0:qQ_HOMEPHONE" => params[:primary_phone],
    "COHShell:_ctl0:qQ_CITY_CONTACT" => params[:city],
    "COHShell:_ctl0:qQ_WORKNUMBER" => params[:secondary_phone],
    "COHShell:_ctl0:qQ_EMAIL" => params[:email],
    "COHShell:_ctl0:qQ_VADDRESS" => params[:complaintStreetAddress],
    "COHShell:_ctl0:qQ_CITY" => params[:complaintCity],
    "COHShell:_ctl0:qQ_VFNAME" => "",
    "COHShell:_ctl0:qQ_VLNAME" => "",
    "COHShell:_ctl0:qQ_COMPOLD" => "",
    "COHShell:_ctl0:qQ_COMP" => params[:complaintComplaint],
    "COHShell:_ctl0:qQ_OCOMP" => "",
    "COHShell:_ctl0:qQ_COMMENTS" => params[:complaintComments],
    "COHShell:_ctl0:Button1" => "Submit Form"
  }

  begin
    uri = URI.parse("http://www.hamilton.ca/Hamilton.Portal/Templates/COHShell.aspx?NRMODE=Published&NRORIGINALURL=%2fCityDepartments%2fCorporateServices%2fITS%2fForms%2bin%2bDevelopment%2fMunicipal%2bLaw%2bEnforcement%2bOnline%2bComplaint%2bForm%2ehtm&NRNODEGUID=%7b4319AA7C-7E5E-4D65-9F46-CCBEC9AB86E0%7d&NRCACHEHINT=Guest")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(post_params)
    response = http.request(request)
    if response.code == "200"
      parse_success_response(response)
    else
      "Error"
    end
  rescue StandardError, Timeout::Error => e
    "Error"
  end
end

def parse_success_response(response)
  # the success page uses javascript to hide the main form and show the success form (thank you, diff!)
  if response.body =~ /document\.getElementById\('mainform'\)\.style\.display = 'none';/
    "Success"
  else
    "There was a problem submitting your complaint on the City's website."
  end
end
