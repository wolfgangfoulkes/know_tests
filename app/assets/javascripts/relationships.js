// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$("#follow_form").html("<%= escape_javascript(render('users/unfollow')) %>");
$("#followers").html('<%= @user.followers.count %>');