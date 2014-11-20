$("#title").empty().append('New Billing manager');
$("#add-new").hide();
$("#new-intended-recipient").empty().append('<%= escape_javascript(render :partial=> "form")%>');