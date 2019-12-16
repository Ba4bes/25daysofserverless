using namespace System.Net

# Input bindings are passed in via param block.
param($Request)

    $HTML = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
</style>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> <html xmlns="http://www.w3.org/1999/xhtml"> <head> <title>HTML TABLE</title> </head><body> <table> <colgroup><col/><col/><col/><col/><col/></colgroup> <tr><th>Name</th><th>Address Line 1</th><th>Address Line 2</th><th>City</th><th>Country</th></tr> <tr><td>Fred</td><td>CandyStreet 141</td><td>1234 AB</td><td>London</td><td>Great Britain</td></tr> <tr><td>Trudy</td><td>Dorpsstraat 12</td><td>12345 DB</td><td>Delfgauw</td><td>Netherlands</td></tr> </table> </body></html>
"@

Push-OutputBinding -Name Response -Value (@{
        StatusCode  = "ok"
        ContentType = "text/html"
        Body        = $HTML
    })



