<html lang="en">


<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Google reCAPTCHA v3 Example</title>
    <script src="https://www.google.com/recaptcha/api.js?render={GOOGLE-CAPTCHA-KEY}"></script>
</head>

<cfscript>
  //  https://developers.google.com/recaptcha/docs/v3

  secret = "{GOOGLE-CAPTCHA-SECRET-KEY}";
  ipaddr = CGI.REMOTE_ADDR;
  googleUrl = "https://www.google.com/recaptcha/api/siteverify";
  success = false;
  errorList = "";
</cfscript>
   

<cfif isDefined("form.actiontype")>
  <!--- DO SOME FORM VALIDATION --->
  <cfif errorList is "">

      <cfset request_url = googleUrl & "?secret=" & secret & "&response=" & form.grc & "&remoteip" & ipaddr>
      
      <cfhttp url="#request_url#" method="get" timeout="10">

        <cfset response = deserializeJSON(cfhttp.filecontent)>
		    <cfif response.success>
           <!--- Check to see if captcha passes.  .75 and above is usually good, the higher the value, the more sure captcha is that it's valid -->
           <cfif response.score gte .75>
              <!--- Send email here, store in DB, etc --->
              <cfset success = true>
           </cfif>
        <cfelse>
             <!--- CAPTCHA FAILS - ACT ACCORDINGLY  -->
        </cfif>

   
  </cfif>

</cfif>

<body>

  <cfoutput>

    <cfif success>
      <h4>Thank you for your submission. We will be in contact with you shortly.</h4>
    <cfelse>
            <form id="contactform" class="contactform" action="" method="post">
                <!-- Field that the JS code will insert a  code to send to Google -->
                <input type="hidden" id="grc" name="grc" value="">
                <p><button class="btn btn-primary" type="button" name="submitrequest" id="submitrequest">Submit Request</button></p>
                <input type="hidden" name="actiontype" value="submit">
            </form>
    </cfif>

  </cfoutput>

</body>


  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    $(document).ready(function() {
      $('#submitrequest').click(function(e) {
        grecaptcha.ready(function() {
          grecaptcha.execute('{google-captcha-key}', {action: 'submit'}).then(function(token) {
              //alert(token);
              $('#grc').val(token);
              $('#contactform').submit();
          });
        });
      });
    });
  </script>

  </html>
