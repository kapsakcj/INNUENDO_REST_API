var innuendoApp = angular.module("innuendoApp", []);

var CURRENT_PROJECT_ID = "";
var CURRENT_PROJECT = {};
var CURRENT_SPECIES_ID = "";
var CURRENT_SPECIES_NAME = "";
var CURRENT_USER_NAME = current_user_name;
var CURRENT_JOBS_ROOT = jobs_root;

var CURRENT_JOB_ID = "";
var CURRENT_PROJECT_NAME_ID = "";

console.log(jobs_root);


var current_job_status_color = {};

var protocols = {};
var protocol_types = [];

$('a').click(function(){
	$(this).parent().addClass("active").siblings().removeClass("active");
});


setTimeout(function(){
	$('#overviewLink').trigger('click');

	$('#offcanvasleft').click(function() {
	  $('.row-offcanvas-left').toggleClass('active');
	});

	$('.nav-a').click(function() {
	  $('.row-offcanvas-left').toggleClass('active');
	});

}, 100);