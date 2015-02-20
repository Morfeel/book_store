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
$(document).ready(function(){
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

  $('#user_email').focusout(function(){
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
  }})
        .done(function (msg){

          formControl.parentNode.classList.add('has-error');
          $(formControl).siblings('.errorStatus').html('This email has been registerred').fadeIn("slow");
        })
        .fail(function(msg){

          formControl.parentNode.classList.remove('has-error');
          $(formControl).siblings('.errorStatus').fadeOut("slow");

        });
      }else{
        formControl.parentNode.classList.add('has-error');
        $(formControl).siblings('.errorStatus').html('Email format is not correct').fadeIn("slow");
      }
    }

  });

  $('#user_password_confirmation, #user_password').focusout(function(){
    var password = $('#user_password');
    var password_confirmation = $('#user_password_confirmation');

    if(isBlank($(this).val())){
      $(this).parent().addClass('has-error');
      $(this).siblings('.errorStatus').html('You cannot leave this blank').fadeIn("slow");
    }else{
      $(this).parent().removeClass('has-error');
      $(this).siblings('.errorStatus').fadeOut("slow");
    }

    if(!isBlank(password.val()) && !isBlank(password_confirmation.val())){
      if(password.val() === password_confirmation.val()){
        password_confirmation.parent().removeClass('has-error');
        password_confirmation.siblings('.errorStatus').fadeOut("slow");
      }else{
        password_confirmation.parent().addClass('has-error');
        password_confirmation.siblings('.errorStatus').html('Password and password confirm do not match').fadeIn("slow");
      }
    }

  });

  $('#user_accept').focusout(function(){
    if(this.checked){
      $(this).parent().parent().removeClass('has-error');
      $(this).parent().siblings('.errorStatus').fadeOut("slow");
    }else{
      $(this).parent().parent().addClass('has-error');
      $(this).parent().siblings('.errorStatus').html('You have to agree to our terms to user our service').fadeIn("slow");
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
});});

function isBlank(str) {
  return (!str || /^\s*$/.test(str));
}

function isUndefined(obj){
  return obj === undefined;
}

