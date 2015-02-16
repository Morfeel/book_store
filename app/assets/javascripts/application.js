// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
var EMAIL_PATT = /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}/i;

$('#search-button').click(function(){
	$(this).hide();
	$('#search').show();
});

$('#close-search').click(function(){
	$('#search').hide();
	$('#search-button').show();
});


$('[data-toggle="popover"]').focusin(function(){
	$(this).popover('show');
});

$('[data-toggle="popover"]').focusout(function(){
	$(this).popover('hide');
});

$('#email').focusout(function(){
  formControl = this;
  var value = this.value;

  if(isBlank(value)){
    formControl.parentNode.classList.add('has-error');
    $(formControl).siblings('.errorStatus').html('You cannot leave this blank').fadeIn("slow");
  }else{
    if (EMAIL_PATT.test(value)){
      
      $.ajax({
        type: "GET",
        url: "api/v1/check",
        data:{ 
          email: value,
          // authenticity_token: authenticity_token
        }})
      .done(function (msg){

        formControl.parentNode.classList.remove('has-error');
        $(formControl).siblings('.errorStatus').fadeOut("slow");
      })
      .fail(function(msg){
        formControl.parentNode.classList.add('has-error');
        $(formControl).siblings('.errorStatus').html('This email has not been registerred').fadeIn("slow");
      });
    }else{
      formControl.parentNode.classList.add('has-error');
      $(formControl).siblings('.errorStatus').html('Email format is not correct').fadeIn("slow");
    }
  }
  
});

$(".not-blank").focusout(function(){
  var value = this.value;

  if(isBlank(value)){
    this.parentNode.classList.add('has-error');
    $(this).siblings('.errorStatus').html('You cannot leave this blank').fadeIn("slow");
  }else{
    this.parentNode.classList.remove('has-error');
    $(this).siblings('.errorStatus').fadeOut("slow");
  }
});



$("#login-form").submit(function(event) {
	// event.preventDefault();
  var form = $(this)[0];

  var email = form["email"].value;
  var password = form["password"].value;

  $.ajax({
  	type: "POST",
  	url: "api/v1/login",
  	data:{ 
      email: email,
  		password: password,
  		// authenticity_token: authenticity_token
  	}})
  .done(function (msg){

  	console.log(msg);
    alert(msg.first_name);
  })
  .fail(function(msg){
    obj = msg.responseJSON;
    if (typeof obj.password != 'undefined'){
      form["password"].parentNode.classList.add('has-error');
      $(form["password"]).siblings('.errorStatus').html(obj.password).fadeIn("slow");
    }
    if (typeof obj.email != 'undefined'){
      form["email"].parentNode.classList.add('has-error');
    }
  });

  
});

function isBlank(str) {
    return (!str || /^\s*$/.test(str));
}